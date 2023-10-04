<?php

namespace App\Exports;

use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;

class AttendanceLogDailyExport implements FromView, ShouldAutoSize
{

    protected $data;
    protected $employee;


    public function __construct($data, $employee)
    {
        $this->data = $data;
        $this->employee = $employee;
    }


    public function view(): View
    {
        return view('export-log-daily-attendances', [
            'data' => $this->data,
            'employee' => $this->employee
        ]);
    }
}
