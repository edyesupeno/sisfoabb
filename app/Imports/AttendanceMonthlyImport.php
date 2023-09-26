<?php

namespace App\Imports;

use Maatwebsite\Excel\Concerns\ToArray;

class AttendanceMonthlyImport implements ToArray
{
    public function array(array $array)
    {
        return $array;
    }
}
