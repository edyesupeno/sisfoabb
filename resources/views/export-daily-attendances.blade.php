<table border="1" style="white-space: nowrap;">
    <tbody>
        <tr>
            <td colspan="6" style="text-align: center;">ATTENDANCES DAILY</td>
        </tr>
        <tr>
            <td colspan="6" style="text-align: center;">{{ $date }}</td>
        </tr>
        <tr>
            <td>Employee Name</td>
            <td>Type</td>
            <td>Schedule</td>
            <td>Clock In</td>
            <td>Clock Out</td>
            <td>Date</td>
        </tr>
        @foreach ($data as $item)
        <tr>
            <td>{{ $item['employee_name'] }}</td>
            <td>
                @if ($item['attendances']['status'] != 'unassigned')
                <span>{{ $item['attendances']['status'] }}</span>
                @else
                <span>-</span>
                @endif
            </td>
            <td>
                @if (isset($item['schedules']) && isset($item['schedules']['shift_detail']))
                <span>{{ $item['schedules']['shift_detail']['start_time']}} - {{ $item['schedules']['shift_detail']['end_time']}}</span>
                @else
                <span>-</span>
                @endif
            </td>
            <td>
                @if (isset($item['attendances']['clock_in']) && $item['attendances']['clock_in'] != '-')
                <span>{{ $item['attendances']['clock_in'] }}</span>
                @else
                <span>-</span>
                @endif
            </td>
            <td>
                @if (isset($item['attendances']['clock_out']) && $item['attendances']['clock_out'] != '-')
                <span>{{ $item['attendances']['clock_out'] }}</span>
                @else
                <span>-</span>
                @endif
            </td>
            <td>{{ $date }}</td>
        </tr>
        @endforeach
    </tbody>
</table>