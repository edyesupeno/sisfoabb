<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithMultipleSheets;

class PayrollSlipExport implements WithMultipleSheets
{
    protected $payroll_slip_id;
    
    public function __construct($payroll_slip_id)
    {
        $this->payroll_slip_id = $payroll_slip_id;
    }

    public function sheets(): array
    {
        return [
            new PayrollFormat($this->payroll_slip_id),
            new SlipFormat($this->payroll_slip_id)
        ];
    }
}
