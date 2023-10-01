<?php

namespace App\Http\Controllers\Project;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Services\Approval\ApprovalService;
use App\Http\Controllers\AdminBaseController;
use App\Http\Requests\Approval\RejectApprovalRequest;
use App\Http\Resources\Approval\ApprovalListResource;
use App\Http\Resources\Approval\SubmitApprovalResource;
use App\Services\Attendance\Attendance\AttendanceOverviewService;

class ProjectController extends AdminBaseController
{
    public function __construct(
        ApprovalService $approvalService,
        AttendanceOverviewService $attendanceOverviewService
    ) {
        $this->approvalService = $approvalService;
        $this->attendanceOverviewService = $attendanceOverviewService;

        $this->title = "ERP ABB | Project";
        $this->path = "project/index";
        $this->data = [];
    }

    public function getData(Request $request)
    {
        try {
            $project = DB::table('branches')
                ->select('branches.*', 'users.id as iduser', 'users.name as nameuser')
                ->join('users', 'users.id', '=', 'branches.manager')
                ->whereNull('branches.deleted_at')
                ->paginate(10);

            return $this->respond($project);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function getAllData()
    {
        try {
            $project = DB::table('branches')
                ->select('branches.*', 'users.id as iduser', 'users.name as nameuser')
                ->join('users', 'users.id', '=', 'branches.manager')
                ->where('status', '=', 'Aktif')
                ->whereNull('branches.deleted_at')
                ->get();

            $projectFilter = [];
            foreach ($project as $itemProject) {
                $request = app(Request::class);
                $request->filter_branch = $itemProject->id;
                // $req->filter_date = '2023-06-01';

                $data = $this->attendanceOverviewService->getAttendanceListTodayDashboard($request);

                $dataFilter = [];
                foreach ($data as $item) {
                    if (in_array($item['attendances'][date('j')]['status'], ['late', 'absent'])) {
                        $item['attendances'] = $item['attendances'][date('j')]['status'];
                        array_push($dataFilter, $item);
                    }
                }

                $itemProject->attendances = $dataFilter;

                array_push($projectFilter, $itemProject);
            }


            return $this->respond($projectFilter);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    //get data area by branch id and pleton by id area
    public function getDataArea(Request $request)
    {
        try {
            $project = DB::table('area')->select('area.*')->where('area.id_branch', $request->id)->whereNull('area.deleted_at')->paginate(10);
            //foreach project 
            foreach ($project as $key => $value) {
                $pleton = DB::table('pleton')->select('pleton.*')->where('pleton.id_area', $value->id)->whereNull('pleton.deleted_at')->get();
                $project[$key]->pleton = $pleton;
            }
            return $this->respond($project);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }
    public function getDataEmploy(Request $request)
    {
        try {
            $project = DB::table('users')->select('users.name', 'users.id')->get();

            return $this->respond($project);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }
}
