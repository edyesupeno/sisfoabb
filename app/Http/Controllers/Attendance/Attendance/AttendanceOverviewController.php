<?php

namespace App\Http\Controllers\Attendance\Attendance;

use Carbon\Carbon;
use Illuminate\Http\Request;
use App\Actions\Options\GetBranchOptions;
use App\Exports\AttendanceMonthlyExport;
use App\Exports\AttendanceMonthlyTemplateExport;
use App\Http\Controllers\AdminBaseController;
use App\Http\Resources\Attendances\Attendance\AttendanceListResource;
use App\Services\Attendance\Attendance\AttendanceOverviewService;
use App\Http\Resources\Attendances\Attendance\AttendanceOverviewResource;
use App\Imports\AttendanceMonthlyImport;
use App\Models\Attendance;
use App\Models\Schedule;
use Carbon\CarbonPeriod;
use Maatwebsite\Excel\Facades\Excel;
use App\Http\Resources\Attendances\Schedule\SubmitScheduleResource;

class AttendanceOverviewController extends AdminBaseController
{
    public function __construct(GetBranchOptions $getBranchOptions, AttendanceOverviewService $attendanceOverviewService)
    {
        $this->getBranchOptions = $getBranchOptions;
        $this->attendanceOverviewService = $attendanceOverviewService;

        $this->title = "ERP ABB | Attendance";
        $this->path = "attendance/attendance/Index";
        $this->data = [
            'branch_list' => $this->getBranchOptions->handle()
        ];
    }

    public function getAttendanceListDate(Request $request)
    {
        try {
            $data = $this->attendanceOverviewService->getAttendanceListDate($request);
            return $this->respond($data);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function getAttendanceRecap(Request $request)
    {
        try {
            $data = $this->attendanceOverviewService->getAttendanceRecap($request);
            return $this->respond($data);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function getAttendanceOverviewData(Request $request)
    {
        try {
            // $data = $this->attendanceOverviewService->getAttendanceOverview($request);
            // $result = new AttendanceOverviewResource($data, 'Success Get Attendance Overview');
            // return $this->respond($result);
            $response_data = [];
            $data = $this->attendanceOverviewService->getAttendanceRecap($request);
            foreach($data as $item){
                $totals = 0;
                foreach($item['recaps'] as $itemRecap){
                    $totals += $itemRecap['total_recap'];
                }
                $response_data[$item['status']] = $totals;
            }

            $result = new AttendanceOverviewResource($response_data, 'Success Get Attendance Overview');
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function getAttendanceList(Request $request)
    {
        try {
            $data = $this->attendanceOverviewService->getAttendanceList($request);
            return $this->respond(new AttendanceListResource($data, 'Success Get Attendance List'));
            // return $this->respond($data);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function getAttendanceListExport(Request $request)
    {
        $startDate = $request->start_date ?: Carbon::now()->format('Y-m') . '-01';
        $endDate = $request->end_date ?: Carbon::now()->format('Y-m') . '-30';

        $period = CarbonPeriod::create($startDate, $endDate);
        $data = $this->attendanceOverviewService->getAttendanceListExport($request);

        return Excel::download(new AttendanceMonthlyExport(
            $data,
            $period,
            $startDate,
            $endDate,
        ), 'attendances-monthly-export.xlsx');
    }

    public function exportAttendanceMonthlyTemplate(Request $request)
    {
        return Excel::download(new AttendanceMonthlyTemplateExport($request), 'attendances-monthly-template.xlsx');
    }

    // public function importAttendanceMonthly(Request $request)
    // {
    //     try {
    //         $data = Excel::toArray(new AttendanceMonthlyImport, $request->file('import_excel'));
    //         for ($i = 3; $i < count($data[0]); $i++) {
    //             $employee_id = explode(' - ', $data[0][$i][0])[0];

    //             foreach ($data[0][$i] as $key => $item) {
    //                 if ($key > 0) {
    //                     $attendance_type = $item == 'SELECT ATTENDANCE' ? null : $item;
    //                     $attendance_date = Carbon::createFromFormat('d/m/Y', $data[0][2][$key])->format('Y-m-d');

    //                     if ($attendance_type != null && $attendance_type == 'Present') {
    //                         $schedule = Schedule::where('user_id', $employee_id)->where('date', $attendance_date)->first();

    //                         Attendance::create([
    //                             'user_id' => $employee_id,
    //                             'status' => 'wfo',
    //                             'clock_in' => $schedule != null ? $schedule->shift_detail->start_time : '00:00:00',
    //                             'clock_out' => $schedule != null ? $schedule->shift_detail->end_time : '00:00:00',
    //                             'date_clock' => $attendance_date
    //                         ]);
    //                     }
    //                 }
    //             }
    //         }
    //         $result = new SubmitScheduleResource(true, 'Success import attendances');
    //         return $this->respond($result);
    //     } catch (\Exception $e) {
    //         return $this->exceptionError($e->getMessage());
    //     }
    // }

    public function importAttendanceMonthly(Request $request)
    {
        try {
            $data = Excel::toArray(new AttendanceMonthlyImport, $request->file('import_excel'));
            for ($i = 3; $i < count($data[0]); $i++) {
                $employee_id = explode(' - ', $data[0][$i][0])[0];

                foreach ($data[0][$i] as $key => $item) {
                    if ($key > 0) {
                        $shift_id = $item == 'SELECT SHIFT' ? null : $item;
                        $shift_date = Carbon::createFromFormat('d/m/Y', $data[0][2][$key])->format('Y-m-d');

                        if ($shift_id != null && strtolower($shift_id) != 'libur') {
                            $schedule = Schedule::where('shift_id', $shift_id)->first();

                            Attendance::create([
                                'user_id' => $employee_id,
                                'status' => 'wfo',
                                'clock_in' => $schedule != null ? $schedule->shift_detail->start_time : '00:00:00',
                                'clock_out' => $schedule != null ? $schedule->shift_detail->end_time : '00:00:00',
                                'date_clock' => $shift_date
                            ]);
                        }

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
            $result = new SubmitScheduleResource(true, 'Success import attendances');
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }
}
