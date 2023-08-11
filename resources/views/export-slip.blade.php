<table border="1" style="white-space: nowrap;">
    <tbody>
        <tr>
            <td>BRANCH</td>
            <td>{{ $data->branch_detail->name }}</td>
        </tr>
        <tr>
            <td>PERIODE</td>
            <td>{{ date('d M Y', strtotime($data->date)) }} - {{ date('d M Y', strtotime($data->end_date)) }}</td>
        </tr>
        <tr>
            <td rowspan="2" style="text-align: center;">Employee External Id</td>
            <td rowspan="2" style="text-align: center;">Employee Name</td>
            <td rowspan="2" style="text-align: center;">Designation</td>
            <td rowspan="2" style="text-align: center;">Account Name</td>
            <td rowspan="2" style="text-align: center;">Account Number</td>
            <td rowspan="2" style="text-align: center;">Work Day</td>
            <td rowspan="2" style="text-align: center;">Overtime</td>
            <td rowspan="2" style="text-align: center;">Take Home Pay</td>
            <td colspan="{{ count($earning) }}" style="text-align: center; background-color: #8ED0A9;">EARNING</td>
            <td colspan="{{ count($deduction) }}" style="text-align: center; background-color: #f4ba84;">DEDUCTION</td>
        </tr>
        <tr>
            @foreach ($earning as $item)
            <td style="background-color: #8ED0A9">{{ $item->name }}</td>
            @endforeach

            @foreach ($deduction as $item)
            <td style="background-color: #f4ba84;">{{ $item->name }}</td>
            @endforeach
        </tr>
        @foreach ($employee_slip as $item)
        <tr>
            <td>{{ $item->employee_detail->employee_external_id }}</td>
            <td>{{ $item->employee_detail->user->name }}</td>
            <td>{{ $item->employee_detail->designation->name }}</td>
            <td>{{ $item->employee_detail->account_name }}</td>
            <td>{{ $item->employee_detail->account_number }}</td>
            <td>{{ $item->attendance }}</td>
            <td>{{ $item->overtime_days }}</td>
            <td>{{ $item->total_amount }}</td>

            {{-- Earning --}}
            @foreach ($item->earning as $ien)
            <td>{{ is_object($ien) ? $ien->value : $ien }}</td>
            @endforeach

            {{-- Deduction --}}
            @foreach ($item->deduction as $idc)
            <td>{{ is_object($idc) ? $idc->value : $idc }}</td>
            @endforeach
        </tr>
        @endforeach
    </tbody>
</table>