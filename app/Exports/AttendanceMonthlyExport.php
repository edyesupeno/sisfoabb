<?php

namespace App\Exports;

use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;

class AttendanceMonthlyExport implements FromView, ShouldAutoSize
{

    protected $data;
    protected $period;
    protected $startDate;
    protected $endDate;

    public function __construct($data, $period, $startDate, $endDate)
    {
        $this->data = $data;
        $this->period = $period;
        $this->startDate = $startDate;
        $this->endDate = $endDate;
    }

    public function view(): View
    {
        return view('export-monthly-attendances', [
            'start_date' => $this->startDate,
            'end_date' => $this->endDate,
            'data' => $this->data,
            'period' => $this->period
        ]);
    }
}
