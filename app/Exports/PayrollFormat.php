<?php

namespace App\Exports;

use App\Models\PayrollSlip;
use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\FromView;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithTitle;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;

class PayrollFormat implements FromView, WithColumnFormatting, ShouldAutoSize, WithTitle
{
    protected $payroll_slip_id;
    
    public function __construct($payroll_slip_id)
    {
        $this->payroll_slip_id = $payroll_slip_id;
    }

    public function view(): View
    {
        $data = PayrollSlip::find($this->payroll_slip_id);
        return view('export-payroll', [
            'data' => $data,
            'slips' => $data->employee_slips
        ]);
    }

    public function columnFormats(): array
    {
        return [
            'C' => NumberFormat::FORMAT_ACCOUNTING_USD,
        ];
    }

    public function title(): string
    {
        return 'Payroll';
    }
}
