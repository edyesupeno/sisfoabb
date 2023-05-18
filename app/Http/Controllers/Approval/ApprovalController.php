<?php

namespace App\Http\Controllers\Approval;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Services\Approval\ApprovalService;
use App\Http\Controllers\AdminBaseController;
use App\Http\Requests\Approval\RejectApprovalRequest;
use App\Http\Resources\Approval\ApprovalListResource;
use App\Http\Resources\Approval\SubmitApprovalResource;
//DB


class ApprovalController extends AdminBaseController
{
    public function __construct(
        ApprovalService $approvalService,
    ) {
        $this->approvalService = $approvalService;
        
        $this->title = "ERP ABB | Approval";
        $this->path = "approval/index";
        $this->data = [];
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
    public function getLembur()
    {
        try {
           //get lembur query join with user and branch
              $lembur = DB::table('lembur')->select('lembur.*','lembur.tanggal as created_at','users.name as created_by','branches.name as branch')->join('users', 'users.id', '=', 'lembur.id_employee')->join('branches', 'branches.id', '=', 'lembur.id_branch')->whereNull('lembur.deleted_at')->paginate(10);
            return $this->respond($lembur);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    //make update status lembur
    public function updateStatusLembur(Request $request)
    {
        try {
            $lembur = DB::table('lembur')->where('id',$request->id)->update(['status'=>$request->status]);
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
}
