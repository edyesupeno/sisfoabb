<table border="1" style="white-space: nowrap;">
    <tbody>
        <tr>
            <td colspan="5" style="text-align: center;">ATTENDANCES DAILY LOG - {{ $employee->user_detail->name }}</td>
        </tr>
        <tr>
            <td colspan="5"></td>
        </tr>
        <tr>
            <td>Date</td>
            <td>Clock In</td>
            <td>Clock Out</td>
            <td>Work Hours</td>
            <td>Status</td>
        </tr>
        @foreach ($data as $item)
        <tr>
            <td>{{ $item['date_clock'] }}</td>
            <td>{{ $item['clock_in'] }}</td>
            <td>{{ $item['clock_out'] }}</td>
            <td>{{ $item['work_hours'] }}</td>
            <td>{{ $item['status'] }}</td>
        </tr>
        @endforeach
    </tbody>
</table>