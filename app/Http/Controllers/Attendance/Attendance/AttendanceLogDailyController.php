<?php

namespace App\Http\Controllers\Attendance\Attendance;

use App\Exports\AttendanceLogDailyExport;
use Inertia\Inertia;
use Illuminate\Http\Request;
use App\Http\Controllers\AdminBaseController;
use App\Services\Employee\Employee\EmployeeService;
use App\Services\Employee\Employee\AttendanceLogService;
use App\Http\Resources\Employees\Employee\AttendanceLogListResource;
use App\Http\Resources\Employees\Employee\AttendanceOverviewResource;
use Carbon\Carbon;
use Maatwebsite\Excel\Facades\Excel;

class AttendanceLogDailyController extends AdminBaseController
{
    public function __construct(
        EmployeeService $employeeService,
        AttendanceLogService $attendanceLogService
    ) {
        $this->employeeService = $employeeService;
        $this->attendanceLogService = $attendanceLogService;
    }

    public function attendanceLogIndex(Request $request, $id)
    {
        $employee = $this->employeeService->getDetailEmployee($id);

        return Inertia::render($this->source . 'attendance/attendance-log-daily/index', [
            "title" => 'ERP ABB | Employee',
            "additional" => [
                'filter_date' => Carbon::parse($request->filter_date ?: Carbon::now())->format('Y-m-d'),
                'employee' => $employee
            ]
        ]);
    }

    public function getAttendanceLogOverviewData($id, Request $request)
    {
        try {
            $employee = $this->employeeService->getDetailEmployee($id);

            $data = $this->attendanceLogService->getAttendanceLogOverview($employee, $request);
            $result = new AttendanceOverviewResource($data, 'Success Get Attendance Overview');
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function getData($id, Request $request)
    {
        try {
            $employee = $this->employeeService->getDetailEmployee($id);

            $data = $this->attendanceLogService->getData($employee, $request);
            $result = new AttendanceLogListResource($data);
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function getDataExport($id, Request $request)
    {
        $employee = $this->employeeService->getDetailEmployee($id);

        $data = $this->attendanceLogService->getDataExport($employee, $request);

        $data_result = [];
        foreach ($data as $item) {
            array_push($data_result, [
                'date_clock'=> Carbon::parse($item['date_clock'])->format('l, d F Y'),
                'clock_in' => $item['clock_in'],
                'clock_out' => $item['clock_out'],
                'work_hours' => $item['total_work_hours'],
                'status' => $item['status']
            ]);
        }

        return Excel::download(new AttendanceLogDailyExport(
            $data_result,
            $employee
        ), 'attendances-log-daily-export.xlsx');
        // return view('export-log-daily-attendances', ['data' => $data_result, 'employee' => $employee]);
    }
}
