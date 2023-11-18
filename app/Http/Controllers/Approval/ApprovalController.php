<?php

namespace App\Http\Controllers\Approval;

use App\Actions\Options\GetBranchOptions;
use App\Exports\LemburExport;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Services\Approval\ApprovalService;
use App\Http\Controllers\AdminBaseController;
use App\Http\Requests\Approval\RejectApprovalRequest;
use App\Http\Resources\Approval\ApprovalListResource;
use App\Http\Resources\Approval\SubmitApprovalResource;
use App\Http\Resources\Attendances\Schedule\SubmitScheduleResource;
use App\Imports\LemburImport;
use App\Models\Employee;
use Carbon\Carbon;
use Maatwebsite\Excel\Facades\Excel;

//DB


class ApprovalController extends AdminBaseController
{
    public function __construct(
        ApprovalService $approvalService,
        GetBranchOptions $getBranchOptions
    ) {
        $this->approvalService = $approvalService;
        $this->getBranchOptions = $getBranchOptions;

        $this->title = "ERP ABB | Approval";
        $this->path = "approval/index";

        $branchOptions = [];
        foreach ($this->getBranchOptions->handle() as $key => $value) {
            $branchOptions[$key] = $value;
        }

        $this->data = [
            'branch_list' => $branchOptions
        ];
    }

    public function getData(Request $request)
    {
        try {
            $data = $this->approvalService->getData($request);
            //get lembur from db


            $result = new ApprovalListResource($data);
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    //make get table lembur
    public function getLembur(Request $request)
    {
        $filter_date = $request->filter_date ?? null;
        $employee_id = $request->employee_id ?? null;
        try {
            //get lembur query join with user and branch
            if ($filter_date != null && $employee_id != null) {
                $lembur = DB::table('lembur')->select('lembur.*', 'lembur.tanggal as created_at', 'users.name as created_by', 'branches.name as branch')->join('users', 'users.id', '=', 'lembur.id_employee')->join('branches', 'branches.id', '=', 'lembur.id_branch')->whereNull('lembur.deleted_at')->whereBetween('lembur', [Carbon::parse($filter_date[0])->format('Y-m-d'), Carbon::parse($filter_date[1])->format('Y-m-d')])->where('id_employee', $employee_id)->paginate(10);
            } else {
                $lembur = DB::table('lembur')->select('lembur.*', 'lembur.tanggal as created_at', 'users.name as created_by', 'branches.name as branch')->join('users', 'users.id', '=', 'lembur.id_employee')->join('branches', 'branches.id', '=', 'lembur.id_branch')->whereNull('lembur.deleted_at')->paginate(10);
            }
            return $this->respond($lembur);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    //make update status lembur
    public function updateStatusLembur(Request $request)
    {
        try {
            $lembur = DB::table('lembur')->where('id', $request->id)->update(['status' => $request->status]);
            return $this->respond($lembur);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }


    public function approveApproval($id, Request $request)
    {
        try {
            $data = $this->approvalService->approveApproval($id, $request);

            $result = new SubmitApprovalResource($data, 'Success Approve Approval');
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function rejectApproval($id, RejectApprovalRequest $request)
    {
        try {
            $data = $this->approvalService->rejectApproval($id, $request);

            $result = new SubmitApprovalResource($data, 'Success Reject Approval');
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function exportTemplate(Request $request)
    {
        return Excel::download(new LemburExport($request), 'lembur-template.xlsx');
    }

    public function importLembur(Request $request)
    {
        try {
            $data = Excel::toArray(new LemburImport, $request->file('import_excel'));
            for ($i = 1; $i < count($data[0]); $i++) {
                $employee_id = explode(' - ', $data[0][$i][0])[0];

                foreach ($data[0][$i] as $key => $item) {
                    if ($key > 0) {
                        $lembur_clock = ($item == '' ? null : $item);
                        $lembur_date = Carbon::createFromFormat('d/m/Y', $data[0][0][$key])->format('Y-m-d');
                        $employee = Employee::where('user_id', $employee_id)->first();

                        if ($lembur_clock != null) {
                            $data_lembur = [
                                'id_employee' => $employee->user_id,
                                'type' => 'Approval Lembur',
                                'id_branch' => $employee->branch_id,
                                'keterangan' => '-',
                                'jam_masuk' => Carbon::parse(explode('|', $lembur_clock)[0])->format('H:i:s'),
                                'jam_keluar' => Carbon::parse(explode('|', $lembur_clock)[1])->format('H:i:s'),
                                'status' => 'approved',
                                'tanggal' => Carbon::parse($lembur_date . ' ' . date('H:i:s'))->format('Y-m-d H:i:s'),
                                'lembur' => Carbon::parse($lembur_date . ' ' . date('H:i:s'))->format('Y-m-d H:i:s'),
                            ];

                            DB::table('lembur')->insert($data_lembur);
                        }
                    }
                }
            }
            $result = new SubmitScheduleResource(true, 'Success Add Lembur');
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }
}
