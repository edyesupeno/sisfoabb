<?php

namespace App\Exports;

use App\Models\Branch;
use Carbon\CarbonPeriod;
use Illuminate\Contracts\View\View;
use Illuminate\Http\Request;
use Maatwebsite\Excel\Concerns\FromView;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use Maatwebsite\Excel\Concerns\WithTitle;

class LemburExport implements FromView, ShouldAutoSize, WithTitle
{
    protected $data;
    protected $period;

    public function __construct(Request $request)
    {
        $this->data = Branch::find($request->query('branch_id'));
        $this->period = CarbonPeriod::create(
            $request->query('start_date'),
            $request->query('end_date')
        );
    }


    public function view(): View
    {
        return view('import-lembur', ['data' => $this->data, 'period' => $this->period]);
    }

    public function title(): string
    {
        return $this->data->name;
    }
}
