<?php

use App\Exports\AllTestValid;
use App\Exports\PayrollSlipExport;
use App\Exports\ScheduleExport;
use App\Exports\Test8;
use App\Http\Controllers\Attendance\Shift\ShiftController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\ResetPasswordController;
use App\Http\Controllers\Auth\ForgotPasswordController;
use App\Imports\ScheduleImport;
use App\Models\Attendance;
use App\Models\Branch;
use App\Models\Employee;
use App\Models\PayrollComponent;
use App\Models\PayrollSlip;
use App\Models\Schedule;
use App\Services\Employee\Employee\AttendanceLogService;
use Carbon\Carbon;
use Carbon\CarbonPeriod;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/



Route::get('/', function () {
    return redirect(route('dashboard.index'));
});

Route::get('/test', function () {
    return Excel::download(new PayrollSlipExport('34'), 'test.xlsx');
});

Route::get('/test2', function () {
    $data = PayrollSlip::find('34');

    $earning = PayrollComponent::where(['type' => 'earning'])->get();
    $deduction = PayrollComponent::where(['type' => 'deduction'])->get();

    $employeeSlips = [];
    foreach ($data->employee_slips as $item) {
        $payrollSlipComponent = [];
        foreach ($item->payroll_slip_components as $ipsc) {
            $payrollSlipComponent[$ipsc->payroll_component_id] = $ipsc;
        }

        $earningComponent = [];
        foreach ($earning as $eC) {
            $earningComponent[] = isset($payrollSlipComponent[$eC->id]) ? $payrollSlipComponent[$eC->id] : 0;
        }

        $deductionComponent = [];
        foreach ($deduction as $dC) {
            $deductionComponent[] = isset($payrollSlipComponent[$dC->id]) ? $payrollSlipComponent[$dC->id] : 0;
        }

        $overtime_days = DB::table('lembur')
            ->where('lembur', '>=', $data->date)
            ->where('lembur', '<=', $data->end_date)
            ->where('id_employee', $item->employee_detail->user_id)
            ->where('status', 'approved')
            ->count();

        $rq = app(Request::class);
        $rq->merge([
            'filter_date' => [Carbon::parse($data->date)->toISOString(), Carbon::parse($data->end_date)->toISOString()],
            'user_id' => $item->employee_detail->user_id
        ]);
        $attendance = app(AttendanceLogService::class)->getAttendanceLogOverview($rq, $rq);

        $item->earning = $earningComponent;
        $item->deduction = $deductionComponent;
        $item->overtime_days = $overtime_days;
        $item->attendance = $attendance['total_present'] + $attendance['total_late'];
        array_push($employeeSlips, $item);
    }

    return view('export-slip', [
        'data' => $data,
        'employee_slip' => $employeeSlips,
        'earning' => $earning,
        'deduction' => $deduction
    ]);
});

Route::get('/test3', function () {
    $data = PayrollSlip::find('34');
    return view('export-payroll', [
        'data' => $data,
        'slips' => $data->employee_slips
    ]);
});

Route::get('/test4', function () {
    return Excel::download(new ScheduleExport, 'schedule.xlsx');
});

Route::get('/test5', function () {
    // return view('import-schedule', [
    //     'data' => Branch::all()[0]
    // ]);

    // dd(Branch::all()[0]->employees);
    return view('test');
});

Route::post('/test6', function (Request $request) {
    // dd($request->file('filer'));
    $data = Excel::toArray(new ScheduleImport, $request->file('filer'));
    // dd($data[0]);
    // foreach ($data as $item) {
    //     echo 'BRANCH : ' . explode(' - ', $item[0][1])[0] . '<br>';
    //     echo 'TANGGAL : ' . ($item[1][1] == 'YYYY-MM-DD' ? 0 : Carbon::createFromDate(1900, 1, 1)->addDays(intval($item[1][1]) - 2)->toISOString()) . '|' . ($item[1][3] == 'YYYY-MM-DD' ? 0 : Carbon::createFromDate(1900, 1, 1)->addDays(intval($item[1][3]) - 2)->toISOString()) . '<br>';
    //     echo 'SHIFT : ' . ($item[2][1] == 'SELECT SHIFT' ? 0 : explode(' - ', $item[2][1])[0]) . '<br>';
    //     echo '<br>';
    //     for ($i = 6; $i < count($item); $i++) {
    //         // echo json_encode($item[$i]) . '<br>';
    //         echo explode(' - ', $item[$i][0])[0] . '|' . $item[$i][1] . '<br>';

    //         if($item[1][1] != 'YYYY-MM-DD' && $item[2][1] != 'SELECT SHIFT' && $item[$i][1] == 'Y'){
    //             $period = CarbonPeriod::create(
    //                 Carbon::createFromDate(1900, 1, 1)->addDays(intval($item[1][1]) - 2)->toISOString(), 
    //                 Carbon::createFromDate(1900, 1, 1)->addDays(intval($item[1][3]) - 2)->toISOString()
    //             );

    //             foreach ($period as $key => $value) {
    //                 $schedule = Schedule::where('user_id', explode(' - ', $item[$i][0])[0])->where('date', $value->format('Y-m-d'))->first();
    //                 $input = [
    //                     'user_id' => explode(' - ', $item[$i][0])[0],
    //                     'shift_id' => strtolower($item[2][1]) == 'libur' ? null : explode(' - ', $item[2][1])[0],
    //                     'is_leave' => strtolower($item[2][1]) == 'libur' ? 1 : 0,
    //                     'date' => $value->format('Y-m-d'),
    //                 ];

    //                 $attendance = Attendance::where('date_clock', $value->format('Y-m-d'))->where('user_id', explode(' - ', $item[$i][0])[0])->first();

    //                 if (isset($schedule) && !isset($attendance)) {
    //                     $schedule->update($input);
    //                 } elseif (!isset($attendance)) {
    //                     Schedule::create($input);
    //                 }
    //             }
    //         }
    //     }
    //     echo '=======================================<br><br>';
    // }
    for ($i = 3; $i < count($data[0]); $i++) {
        $employee_id = explode(' - ', $data[0][$i][0])[0];

        foreach ($data[0][$i] as $key => $item) {
            if ($key > 0) {
                $shift_id = $item == 'SELECT SHIFT' ? null : $item;
                $shift_date = Carbon::createFromFormat('d/m/Y', $data[0][2][$key])->format('Y-m-d');
                
                if ($shift_id != null) {
                    $schedule = Schedule::where('user_id', $employee_id)->where('date', $shift_date)->first();
                    $input = [
                        'user_id' => $employee_id,
                        'shift_id' => strtolower($shift_id) == 'libur' ? null : explode(' - ', $shift_id)[0],
                        'is_leave' => strtolower($shift_id) == 'libur' ? 1 : 0,
                        'date' => $shift_date,
                    ];

                    $attendance = Attendance::where('date_clock', $shift_date)->where('user_id', $employee_id)->first();

                    if (isset($schedule) && !isset($attendance)) {
                        $schedule->update($input);
                    } elseif (!isset($attendance)) {
                        Schedule::create($input);
                    }
                }
            }
        }
    }
    echo 'SUKSES';
})->name('test');

Route::get('/test7', function () {
    $period = CarbonPeriod::create('2023-08-09', '2023-08-12');
    return $period;
});

Route::get('/test8', function (Request $request) {
    $branch = Branch::find($request->query('branch_id'));
    $period = CarbonPeriod::create(
        $request->query('start_date'),
        $request->query('end_date')
    );

    return view('import', ['data' => $branch, 'period' => $period]);
});

// Route::get('/test9', function () {
//     return Excel::download(new Test8, 'sh.xlsx');
// });


Route::prefix('admin')->group(function () {
    Route::controller(LoginController::class)->group(function () {
        Route::get('login', 'showLoginForm')->name('login');
        Route::get('success-reset', 'showSuccessResetPassword')->name('successreset');
        Route::post('login', 'login');
        Route::middleware(['auth'])->group(function () {
            Route::post('logout', 'logout')->name('logout');
        });
    });
    Route::controller(ResetPasswordController::class)->group(function () {
        Route::get('password/reset/{token}', 'showResetForm')->name('showResetForm');
        Route::post('password/reset', 'reset')->name('resetpassword');
    });
    Route::controller(ForgotPasswordController::class)->group(function () {
        Route::get('password/reset', 'showLinkRequestForm')->name('showlinkrequestform');
        Route::post('password/email', 'sendResetLinkEmail')->name('sendresetlinkemail');
    });

    Route::middleware(['auth', 'CanDashboard'])->group(function () {
        Route::get('/', function () {
            return redirect(route('dashboard.index'));
        });

        Route::controller(HomeController::class)->group(function () {
            Route::get('/dashboard', 'index')->name('dashboard.index');
        });

        require __DIR__ . '/admin/settings.php';

        require __DIR__ . '/admin/employee.php';
        require __DIR__ . '/admin/attendance.php';
        require __DIR__ . '/admin/leave.php';
        require __DIR__ . '/admin/payroll.php';
        require __DIR__ . '/admin/noticeboard.php';
        require __DIR__ . '/admin/approval.php';
        require __DIR__ . '/admin/project.php';
    });
});
