<?php

namespace App\Http\Controllers\Attendance\Attendance;

use Carbon\Carbon;
use Illuminate\Http\Request;
use App\Actions\Options\GetBranchOptions;
use App\Exports\AttendanceDailyExport;
use App\Exports\AttendanceMonthlyExport;
use App\Exports\AttendanceMonthlyTemplateExport;
use App\Http\Controllers\AdminBaseController;
use App\Http\Resources\Attendances\Attendance\AttendanceListResource;
use App\Services\Attendance\Attendance\AttendanceOverviewService;
use App\Http\Resources\Attendances\Attendance\AttendanceOverviewResource;
use App\Imports\AttendanceMonthlyImport;
use App\Models\Attendance;
use App\Models\Schedule;
use Carbon\CarbonPeriod;
use Maatwebsite\Excel\Facades\Excel;
use App\Http\Resources\Attendances\Schedule\SubmitScheduleResource;
use App\Services\Attendance\Attendance\AttendanceDailyService;
use Illuminate\Support\Facades\DB;

class AttendanceDailyController extends AdminBaseController
{
    public function __construct(GetBranchOptions $getBranchOptions, AttendanceDailyService $attendanceDailyService, Request $request)
    {
        $this->getBranchOptions = $getBranchOptions;
        $this->attendanceDailyService = $attendanceDailyService;

        $this->title = "ERP ABB | Attendance";
        $this->path = "attendance/attendance-daily/Index";
        $this->data = [
            'branch_list' => $this->getBranchOptions->handle(),
            'branch_id' => $request->query('branch_id', '1')
        ];
    }


    public function getAttendanceOverviewData(Request $request)
    {
        try {
            // $data = $this->attendanceDailyService->getAttendanceOverview($request);
            // $result = new AttendanceOverviewResource($data, 'Success Get Attendance Overview');
            // return $this->respond($result);
            $filter_date = $request->filter_date ?: Carbon::now();

            $response_data = [];
            $data = $this->attendanceDailyService->getAttendanceRecap($request);
            foreach ($data as $item) {
                $totals = 0;
                foreach ($item['recaps'] as $tgl => $itemRecap) {
                    if (Carbon::parse($filter_date)->format('j') == $tgl) {
                        $totals = $itemRecap['total_recap'];
                        break;
                    }
                }
                $response_data[$item['status']] = $totals;
            }

            $result = new AttendanceOverviewResource($response_data, 'Success Get Attendance Overview');
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function getAttendanceList(Request $request)
    {
        try {
            $data = $this->attendanceDailyService->getAttendanceList($request);
            return $this->respond(new AttendanceListResource($data, 'Success Get Attendance List'));
            // return $this->respond($data);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function getAttendanceListExport(Request $request)
    {
        $date = $request->filter_date ?: Carbon::now()->format('Y-m-d');
        $data = $this->attendanceDailyService->getAttendanceListExport($request)['attendances'];

        // return $this->respond($data[0]['attendances']['clock_in']);
        return Excel::download(new AttendanceDailyExport(
            $data,
            $date
        ), 'attendances-daily-export.xlsx');
    }

    public function updateAttendance(Request $request)
    {
        $id = $request->id;
        $clock_in = Carbon::parse($request->clock_in)->format('H:i:s');
        $clock_out = Carbon::parse($request->clock_out)->format('H:i:s');

        $attendance = Attendance::where('id', $id)->first();
        $attendance->update([
            'clock_in' => $clock_in,
            'clock_out' => $clock_out
        ]);

        return $this->respond([
            "success" => true,
            "message" => "Success update attendance"
        ]);
    }

    public function saveLembur(Request $request)
    {
        $data = [
            'id_employee' => $request->user_id,
            'type' => 'Approval Lembur',
            'id_branch' => $request->branch_id,
            'keterangan' => $request->note,
            'jam_masuk' => Carbon::parse($request->clock_in)->format('H:i:s'),
            'jam_keluar' => Carbon::parse($request->clock_out)->format('H:i:s'),
            'status' => 'approved',
            'tanggal' => Carbon::parse($request->date . ' ' . date('H:i:s'))->format('Y-m-d H:i:s'),
            'lembur' => Carbon::parse($request->date . ' ' . date('H:i:s'))->format('Y-m-d H:i:s'),
        ];

        DB::table('lembur')->insert($data);

        return $this->respond([
            "success" => true,
            "message" => "Success save lembur"
        ]);
    }

    public function cancelLembur($id)
    {
        DB::table('lembur')->where('id', $id)->delete();

        return $this->respond([
            "success" => true,
            "message" => "Success cancel lembur"
        ]);
    }
}
