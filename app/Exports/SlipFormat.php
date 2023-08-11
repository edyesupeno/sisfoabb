<?php

namespace App\Exports;

use App\Models\PayrollComponent;
use App\Models\PayrollSlip;
use App\Services\Employee\Employee\AttendanceLogService;
use Carbon\Carbon;
use Illuminate\Contracts\View\View;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Concerns\FromView;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithTitle;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;

class SlipFormat implements FromView, ShouldAutoSize, WithColumnFormatting, WithTitle
{
    protected $payroll_slip_id;
    
    public function __construct($payroll_slip_id)
    {
        $this->payroll_slip_id = $payroll_slip_id;
    }
    
    public function view(): View
    {
        $data = PayrollSlip::find($this->payroll_slip_id);

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
    }

    public function columnFormats(): array
    {
        return [
            'H' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'I' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'J' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'K' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'L' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'M' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'N' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'O' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'P' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'Q' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'R' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'S' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'T' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'U' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'V' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'W' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'X' => NumberFormat::FORMAT_ACCOUNTING_USD,
            'Y' => NumberFormat::FORMAT_ACCOUNTING_USD,
        ];
    }

    public function title(): string
    {
        return 'Slip Gaji';
    }
}
