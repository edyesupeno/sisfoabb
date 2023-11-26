<?php

namespace App\Http\Controllers\Payroll\Payroll;

use Carbon\Carbon;
use Inertia\Inertia;
use App\Models\Branch;
use Illuminate\Http\Request;
use App\Services\FileService;
use Illuminate\Support\Facades\DB;
use App\Actions\Options\GetBranchOptions;
use App\Exports\PayrollSlipExport;
use App\Helpers\Utility\Payroll\Calculate;
use App\Helpers\Utility\Payroll\Component;
use App\Http\Controllers\AdminBaseController;
use App\Services\Payroll\Payroll\RunPayrollService;
use App\Http\Requests\Payroll\Payroll\GeneratePayroll;
use App\Http\Requests\Payroll\Payroll\PaidAllSlipRequest;
use App\Http\Resources\Payroll\Payroll\SubmitPayrollResource;
use App\Http\Requests\Payroll\Payroll\UpdatePayrollSlipRequest;
use App\Http\Resources\Payroll\Payroll\PayrollSlipListResource;
use App\Http\Resources\Payroll\Payroll\PayrollEmployeeListResource;
use App\Models\PayrollComponent;
use App\Services\Employee\Employee\AttendanceLogService;
use App\Services\Employee\Employee\EmployeeService;
use Maatwebsite\Excel\Facades\Excel;

class PayrollController extends AdminBaseController
{
    public function __construct(
        GetBranchOptions $getBranchOptions,
        RunPayrollService $runPayrollService,
        FileService $fileService
    ) {
        $this->getBranchOptions = $getBranchOptions;
        $this->runPayrollService = $runPayrollService;
        $this->fileService = $fileService;

        // Filter Branches
        $branchOptions = [
            'all' => 'All Branches'
        ];
        foreach ($this->getBranchOptions->handle() as $key => $value) {
            $branchOptions[$key] = $value;
        }

        $this->title = "ERP ABB | Payroll";
        $this->path = "payroll/payroll/index";
        $this->data = [
            'branches_list' => $branchOptions
        ];
    }

    public function getData(Request $request)
    {
        try {
            $data = $this->runPayrollService->getData($request);

            $result = new PayrollSlipListResource($data);
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function generatePayroll(GeneratePayroll $request)
    {
        try {
            $dates = collect($request->date)->map(function ($q) {
                return Carbon::parse($q)->format('Y-m-d');
            })->toArray();

            // Calculate payroll base on branch selected
            if ($request->branch_id != 'all') {
                // WITH BRANCH ID
                DB::beginTransaction();

                $this->runPayrollService->calculatePayroll($request->branch_id, $dates[0], $dates[1]);

                DB::commit();
            } else {
                // ALL
                DB::beginTransaction();

                $payroll_slip = $this->runPayrollService->createSlipPayrollAllPlacement($dates[0], $dates[1]);

                $this->runPayrollService->calculatePayroll(null, $dates[0], $dates[1], $payroll_slip);

                DB::commit();
            }

            $result = new SubmitPayrollResource(true, 'Success Generate Payroll');
            return $this->respond($result);
        } catch (\Exception $e) {
            DB::rollback();
            return $this->exceptionError($e->getMessage());
        }
    }

    public function deleteSlip($id)
    {
        try {
            $data = $this->runPayrollService->deleteSlip($id);

            $result = new SubmitPayrollResource($data, 'Success Delete Payroll');
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function payrollEmployee($id, Request $request)
    {
        return Inertia::render($this->source . 'payroll/payroll/payrollemployee/index', [
            "title" => 'ERP ABB | Payroll',
            "additional" => [
                'payroll_slip_id' => $id,
                'export_url' => route('payroll.run.payrollexport', ['id' => $id])
            ]
        ]);
    }

    public function getPayrollEmployeeData($id, Request $request)
    {
        try {
            $data = $this->runPayrollService->getPayrollEmployeeData($id, $request);

            $result = new PayrollEmployeeListResource($data);
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function payrollEmployeeDetail($id)
    {
        $payrollEmployee = $this->runPayrollService->getPayrollEmployeeDetail($id);

        $tunjangan_jabatan = collect($this->runPayrollService->getEarningEmployeeSlipComponents($id))->firstWhere('name', 'TUNJANGAN JABATAN')['value'] + $payrollEmployee->amount;

        return Inertia::render($this->source . 'payroll/payroll/payrollemployee/detail', [
            "title" => 'ERP ABB | Payroll',
            "additional" => [
                'payroll_employee' => $payrollEmployee,
                'payroll_date' => Carbon::parse($payrollEmployee->payroll_slip->date)->format('F Y'),
                'base_salary' => number_format($payrollEmployee->amount, 2, ',', '.'),
                'total_earning' => number_format($payrollEmployee->earning_total + $payrollEmployee->amount + (($tunjangan_jabatan * 4.89)/100), 2, ',', '.'),
                'total_deduction' => number_format($payrollEmployee->deduction_total + (($tunjangan_jabatan * 4.89)/100), 2, ',', '.'),
                'take_home_pay' => number_format($payrollEmployee->total_amount, 2, ',', '.'),
                'tunjangan_bpjs' => number_format($tunjangan_jabatan, 2, ',', '.'),
                'bpjs_tk' => number_format(($tunjangan_jabatan * 4.89)/100, 2, ',', '.'),
                'bpjs_jht' => number_format(($tunjangan_jabatan * 3.70)/100, 2, ',', '.'),
                'bpjs_jkk' => number_format(($tunjangan_jabatan * 0.89)/100, 2, ',', '.'),
                'bpjs_jkm' => number_format(($tunjangan_jabatan * 0.30)/100, 2, ',', '.'),
                'earning_components' => $this->runPayrollService->getEarningEmployeeSlipComponents($id),
                'deduction_components' => $this->runPayrollService->getDeductionEmployeeSlipComponents($payrollEmployee),
                'start_date' => $payrollEmployee->payroll_slip->date,
                'end_date' => $payrollEmployee->payroll_slip->end_date,
                'user_id' => $payrollEmployee->employee_detail->user_id
            ]
        ]);

    }

    public function payrollEmployeeEdit($id)
    {
        $payrollEmployee = $this->runPayrollService->getPayrollEmployeeDetail($id);
        $payrollComponent = Component::getComponentPayroll($payrollEmployee->employee_detail->branch_id, $payrollEmployee->employee_id);

        return Inertia::render($this->source . 'payroll/payroll/payrollemployee/edit', [
            "title" => 'ERP ABB | Payroll',
            "additional" => [
                'payroll_employee' => $payrollEmployee,
                'user_id' => $payrollEmployee->employee_detail->user_id,
                'start_date' => $payrollEmployee->payroll_slip->date,
                'end_date' => $payrollEmployee->payroll_slip->end_date,
                'payroll_date' => Carbon::parse($payrollEmployee->payroll_slip->date)->format('F Y'),
                'base_salary' => number_format($payrollEmployee->amount, 2, ',', '.'),
                'total_earning' => number_format($payrollEmployee->earning_total + $payrollEmployee->amount, 2, ',', '.'),
                'total_deduction' => number_format($payrollEmployee->deduction_total, 2, ',', '.'),
                'take_home_pay' => number_format($payrollEmployee->total_amount, 2, ',', '.'),
                'earning_components' => $this->runPayrollService->getEarningEmployeeSlipComponents($id),
                'deduction_components' => $this->runPayrollService->getDeductionEmployeeSlipComponents($payrollEmployee),
                'payroll_earning_components' => collect($payrollComponent)->where('type', 'earning')->values()->map(function ($q) use ($payrollEmployee) {
                    $value = Calculate::calculateDefaultAmountComponent($q, $payrollEmployee->employee_id, $payrollEmployee->employee_detail->branch_id);

                    return [
                        'id' => $q->id,
                        'name' => $q->name,
                        'is_editable' => $q->is_editable,
                        'is_taxable' => $q->is_taxable,
                        'type' => $q->type,
                        'value' => (int) $value,
                        'amount' => number_format($value, 2, ',', '.')
                    ];
                }),
                'payroll_deduction_components' => collect($payrollComponent)->where('type', 'deduction')->values()->map(function ($q) use ($payrollEmployee) {
                    $value = Calculate::calculateDefaultAmountComponent($q, $payrollEmployee->employee_id, $payrollEmployee->employee_detail->branch_id);

                    return [
                        'id' => $q->id,
                        'name' => $q->name,
                        'is_editable' => $q->is_editable,
                        'is_taxable' => $q->is_taxable,
                        'type' => $q->type,
                        'value' => (int) $value,
                        'amount' => number_format($value, 2, ',', '.')
                    ];
                })
            ]
        ]);
    }

    public function payrollEmployeeUpdate($id, UpdatePayrollSlipRequest $request, AttendanceLogService $attendanceLogService)
    {

        $request->merge(['filter_date' => [Carbon::parse($request->start_date)->toISOString(), Carbon::parse($request->end_date)->toISOString()]]);

        $earningComponents = [];
        foreach ($request->earningComponents as $i => $val) {
            $payroll = PayrollComponent::find($val['payroll_component_id']);
            $payType = isset($payroll->pay_type) ? $payroll->pay_type : 'fix';
            $totalCross = 1;
            switch ($payType) {
                case "fix":
                    $totalCross = 1;
                    break;
                case "attendance":
                    $attendance = $attendanceLogService->getAttendanceLogOverview($request, $request);
                    $totalCross = $attendance['total_present'] + $attendance['total_late'];
                    break;
                case "overtime_days":
                    $lembur = DB::table('lembur')
                        ->where('lembur', '>=', $request->start_date)
                        ->where('lembur', '<=', $request->end_date)
                        ->where('id_employee', $request->user_id)
                        ->where('status', 'approved')
                        ->count();
                    $totalCross = $lembur;
                    break;
                case "overtime_hours":
                    $lembur = DB::table('lembur')
                        ->where('lembur', '>=', $request->start_date)
                        ->where('lembur', '<=', $request->end_date)
                        ->where('id_employee', $request->user_id)
                        ->where('status', 'approved')
                        ->get()->map(function ($item) {
                            $startTime = strtotime($item->jam_masuk);
                            $endTime = strtotime($item->jam_keluar);
                            $diffInSeconds = $endTime - $startTime;
                            $hours = floor($diffInSeconds / 3600);
                            $minutes = floor(($diffInSeconds % 3600) / 60);
                            if ($minutes >= 30) {
                                $hours += 1;
                            }
                            return (int)$hours;
                        });
                    $totalCross = $lembur->sum();
                    break;
                default:
                    $totalCross = 1;
                    break;
            }
            $val['total_cross'] = $totalCross;
            $earningComponents[] = $val;
        }

        $deductionComponents = [];
        foreach ($request->deductionComponents as $i => $val) {
            if ($i > 0) {
                $payroll = PayrollComponent::find($val['payroll_component_id']);
                $payType = isset($payroll->pay_type) ? $payroll->pay_type : 'fix';
                $totalCross = 1;
                switch ($payType) {
                    case "fix":
                        $totalCross = 1;
                        break;
                    case "attendance":
                        $attendance = $attendanceLogService->getAttendanceLogOverview($request, $request);
                        $totalCross = $attendance['total_present'] + $attendance['total_late'];
                        break;
                    case "overtime_days":
                        $lembur = DB::table('lembur')
                            ->where('lembur', '>=', $request->start_date)
                            ->where('lembur', '<=', $request->end_date)
                            ->where('id_employee', $request->user_id)
                            ->where('status', 'approved')
                            ->count();
                        $totalCross = $lembur;
                        break;
                    case "overtime_hours":
                        $lembur = DB::table('lembur')
                            ->where('lembur', '>=', $request->start_date)
                            ->where('lembur', '<=', $request->end_date)
                            ->where('id_employee', $request->user_id)
                            ->where('status', 'approved')
                            ->get()->map(function ($item) {
                                $startTime = strtotime($item->jam_masuk);
                                $endTime = strtotime($item->jam_keluar);
                                $diffInSeconds = $endTime - $startTime;
                                $hours = floor($diffInSeconds / 3600);
                                $minutes = floor(($diffInSeconds % 3600) / 60);
                                if ($minutes >= 30) {
                                    $hours += 1;
                                }
                                return (int)$hours;
                            });
                        $totalCross = $lembur->sum();
                        break;
                    default:
                        $totalCross = 1;
                        break;
                }
                $val['total_cross'] = $totalCross;
            } else {
                $val['total_cross'] = 1;
            }
            $deductionComponents[] = $val;
        }

        $request->merge(['earningComponents' => $earningComponents, 'deductionComponents' => $deductionComponents]);

        try {
            $slip = $this->runPayrollService->updateStatusEmployeeSlip($id, $request);
            $this->runPayrollService->updateEmployeeSlip($slip, $request);

            $result = new SubmitPayrollResource(true, 'Success Update Payroll');
            return $this->respond($result);
        } catch (\Exception $e) {
            DB::rollback();
            return $this->exceptionError($e->getMessage());
        }
    }

    public function payrollEmployeePaidAll($id, PaidAllSlipRequest $request)
    {
        try {
            $this->runPayrollService->paidAllSlipEmployee($id, $request);

            $result = new SubmitPayrollResource(true, 'Success Paid All Slip Payroll');
            return $this->respond($result);
        } catch (\Exception $e) {
            DB::rollback();
            return $this->exceptionError($e->getMessage());
        }
    }

    public function payrollEmployeeDelete($id)
    {
        try {
            $this->runPayrollService->deleteSlipEmployee($id);

            $result = new SubmitPayrollResource(true, 'Success Delete Slip Payroll');
            return $this->respond($result);
        } catch (\Exception $e) {
            DB::rollback();
            return $this->exceptionError($e->getMessage());
        }
    }

    public function payrollExport($id)
    {
        return Excel::download(new PayrollSlipExport($id), 'Slip_Gaji_' . $id . '.xlsx');
    }
}
