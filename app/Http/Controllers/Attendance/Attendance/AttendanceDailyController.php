<?php

namespace App\Http\Controllers\Attendance\Attendance;

use Carbon\Carbon;
use Illuminate\Http\Request;
use App\Actions\Options\GetBranchOptions;
use App\Exports\AttendanceDailyExport;
use App\Exports\AttendanceMonthlyExport;
use App\Exports\AttendanceMonthlyTemplateExport;
use App\Http\Controllers\AdminBaseController;
use App\Services\Attendance\Attendance\AttendanceOverviewService;
use App\Http\Resources\Attendances\Attendance\AttendanceOverviewResource;
use App\Imports\AttendanceMonthlyImport;
use App\Models\Attendance;
use App\Models\Schedule;
use Carbon\CarbonPeriod;
use Maatwebsite\Excel\Facades\Excel;
use App\Http\Resources\Attendances\Schedule\SubmitScheduleResource;
use App\Services\Attendance\Attendance\AttendanceDailyService;

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
            $data = $this->attendanceDailyService->getAttendanceOverview($request);
            $result = new AttendanceOverviewResource($data, 'Success Get Attendance Overview');
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function getAttendanceList(Request $request)
    {
        try {
            $data = $this->attendanceDailyService->getAttendanceList($request);
            return $this->respond($data);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function getAttendanceListExport(Request $request)
    {
        $date = $request->filter_date ?: Carbon::now()->format('Y-m-d');
        $data = $this->attendanceDailyService->getAttendanceList($request);

        // return $this->respond($data[0]['attendances']['clock_in']);
        return Excel::download(new AttendanceDailyExport(
            $data,
            $date
        ), 'attendances-daily-export.xlsx');
    }

}
