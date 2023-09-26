<table border="1" style="white-space: nowrap;">
    <tbody>
        <tr>
            <td colspan="{{ count($period)+1 }}" style="text-align: center;">ATTENDANCES MONTHLY</td>
        </tr>
        <tr>
            <td colspan="{{ count($period)+1 }}" style="text-align: center;">{{ $start_date }} s.d. {{ $end_date }}</td>
        </tr>
        <tr>
            <td>Employee Name</td>
            @foreach ($period as $item)
            <td>{{ $item->format('Y/m/d') }}</td>
            @endforeach
        </tr>
        @foreach ($data as $item)
        <tr>
            <td>{{ $item['employee_name'] }}</td>
            @foreach ($item['attendances'] as $attendance)
                <td>{{ $attendance['status'] }}</td>
            @endforeach
        </tr>
        @endforeach
    </tbody>
</table>