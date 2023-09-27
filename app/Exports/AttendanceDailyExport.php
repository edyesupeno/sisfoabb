<?php

namespace App\Exports;

use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;

class AttendanceDailyExport implements FromView, ShouldAutoSize
{

    protected $data;
    protected $date;

    
    public function __construct($data, $date)
    {
        $this->data = $data;
        $this->date =$date;
    }
    

    public function view(): View
    {
        return view('export-daily-attendances', [
            'data' => $this->data,
            'date' => $this->date
        ]);   
    }
}
