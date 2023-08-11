<?php

namespace App\Exports;

use App\Models\Branch;
use Carbon\CarbonPeriod;
use Illuminate\Contracts\View\View;
use Illuminate\Http\Request;
use Maatwebsite\Excel\Concerns\FromView;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use Maatwebsite\Excel\Concerns\WithEvents;
use Maatwebsite\Excel\Concerns\WithTitle;
use Maatwebsite\Excel\Events\AfterSheet;
use PhpOffice\PhpSpreadsheet\Cell\DataValidation;

class ScheduleExport implements FromView, ShouldAutoSize, WithEvents, WithTitle
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
        return view('import', ['data' => $this->data, 'period' => $this->period]);
    }

    public function registerEvents(): array
    {
        return [
            AfterSheet::class => function (AfterSheet $event) {
                $sheet = $event->sheet;

                foreach ($this->cellAlphabet('B', count($this->period)) as $item) {
                    foreach ($this->data->employees as $i => $employee) {
                        $sheet->setCellValue($item . ($i + 4), "SELECT SHIFT");
                        $configs = implode(',', array_merge($this->data->shifts->map(function ($shift) {
                            return $shift->id . ' - ' . $shift->name;
                        })->toArray(), ["Libur"]));
                        $objValidation = $sheet->getCell($item . ($i + 4))->getDataValidation();
                        $objValidation->setType(DataValidation::TYPE_LIST);
                        $objValidation->setErrorStyle(DataValidation::STYLE_INFORMATION);
                        $objValidation->setAllowBlank(false);
                        $objValidation->setShowInputMessage(true);
                        $objValidation->setShowErrorMessage(true);
                        $objValidation->setShowDropDown(true);
                        $objValidation->setErrorTitle('Input error');
                        $objValidation->setError('Value is not in list.');
                        $objValidation->setPromptTitle('Pilih Shift');
                        $objValidation->setPrompt('Silahkan pilih shift yang diinginkan.');
                        $objValidation->setFormula1('"' . $configs . '"');
                    }
                }
            }
        ];
    }

    private function cellAlphabet($startLetter = 'A', $loopLength = 1)
    {
        $startNumber = ord($startLetter) - ord('A') + 1;

        $letters = [];
        for ($i = $startNumber; $i < $startNumber + $loopLength; $i++) {
            $currentLetter = chr($i + ord('A') - 1);
            $letters[] = $currentLetter;
        }

        return $letters;
    }

    public function title(): string
    {
        return $this->data->name;
    }
}
