<table border="1" style="white-space: nowrap;">
    <tbody>
        <tr>
            <td style="background-color: black; color: white;">REKENING</td>
            <td style="background-color: black; color: white;">PLUS</td>
            <td style="background-color: black; color: white;">NOMINAL</td>
            <td style="background-color: black; color: white;">CD</td>
            <td style="background-color: black; color: white;">NO</td>
            <td style="background-color: black; color: white;">NAMA</td>
            <td style="background-color: black; color: white;">KETERANGAN</td>
        </tr>
        @foreach ($slips as $i => $item)
            <tr>
                <td>{{ $item->employee_detail->account_number }}</td>
                <td>+</td>
                <td>{{ $item->total_amount }}</td>
                <td>C</td>
                <td>{{ str_pad($i+1, 4, 0, STR_PAD_LEFT) }}</td>
                <td>{{ $item->employee_detail->user->name }}</td>
                <td>Gaji Periode {{ date('d M Y', strtotime($data->date)) }} - {{ date('d M Y', strtotime($data->end_date)) }}</td>
            </tr>
        @endforeach
    </tbody>
</table>