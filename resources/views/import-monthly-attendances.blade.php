<table border="1">
    <tr>
        <td colspan="{{ count($period) + 1 }}"
            style="text-align: center; white-space: nowrap; background-color: black; color: white;">{{ $data->name }}
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td style="text-align: center; white-space: nowrap; background-color: black; color: white;">Employee</td>
        @foreach ($period as $item)
        <td style="text-align: center; white-space: nowrap; background-color: black; color: white;">{{
            $item->format('d/m/Y') }}</td>
        @endforeach
    </tr>
    @foreach ($data->employees as $item)
    <tr>
        <td style="white-space: nowrap;">{{ $item->user->id }} - {{ $item->user->name }}</td>
        @for ($i = 0; $i < count($period); $i++)<td>attendance</td>@endfor
    </tr>
    @endforeach
</table>