<?php

namespace App\Http\Controllers\Api\V1\Approval;

use Illuminate\Http\Request;
use App\Http\Controllers\ApiBaseController;
use App\Services\Api\V1\Approval\ApprovalService;
use App\Http\Requests\Api\V1\Approval\RejectApprovalRequest;
use App\Http\Resources\Api\V1\Approval\ApprovalListResource;
use App\Http\Requests\Api\V1\Approval\ApproveApprovalRequest;
use App\Http\Resources\Api\V1\Approval\ApprovalDetailResource;
use App\Http\Resources\Api\V1\Approval\RejectApprovalResource;
use App\Http\Resources\Api\V1\Approval\ApproveApprovalResource;

class ApprovalController extends ApiBaseController
{
    public function __construct(ApprovalService $approvalService)
    {
        $this->approvalService = $approvalService;
    }

    public function getApprovalData(Request $request)
    {
        try {
            $data = $this->approvalService->getData($request);  

            $result = new ApprovalListResource($data);
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function getLemburData(Request $request)
    {
        try {
            //get lembur query join with user and branch where id branch = id branch rquest and status
            $lembur = DB::table('lembur')->select('lembur.*','lembur.tanggal as created_at','users.name as created_by','branches.name as branch')->join('users', 'users.id', '=', 'lembur.id_employee')->join('branches', 'branches.id', '=', 'lembur.id_branch')->where('lembur.id_branch',$request->id_branch)->where('lembur.status',$request->status)->whereNull('lembur.deleted_at')->paginate(10);
             return $this->respond($lembur);
         } catch (\Exception $e) {
             return $this->exceptionError($e->getMessage());
         }
    }
    //add lembur
    public function addLembur(Request $request)
    {
        try {
            //insert lembur
            //cek if employee id attendanve now with date_clock column and  clock_in and clock_out is not null
            $cek = DB::table('attendance')->where('id_employee',$request->id_employee)->where('date_clock',date('Y-m-d'))->whereNotNull('clock_in')->whereNotNull('clock_out')->first();
            if($cek){
                $lembur = DB::table('lembur')->insert(['id_employee'=>$request->id_employee,'id_branch'=>$request->id_branch,'tanggal'=>$request->tanggal,'waktu_masuk'=>$request->waktu_masuk,'waktu_keluar'=>$request->waktu_keluar,'status'=>'awaiting']);
                return $this->respond($lembur);
            }else{
                return $this->respond('Anda belum absen hari ini');
            }
            
            
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    //approve lembur
    public function approveLembur(Request $request)
    {
        try {
            //update waktu_masuk and waktu_keluar and status to approve
            $lembur = DB::table('lembur')->where('id',$request->id)->update(['waktu_masuk'=>$request->waktu_masuk,'waktu_keluar'=>$request->waktu_keluar,'status'=>'approved']);
            return $this->respond($lembur);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }
    //reject lembur
    public function rejectLembur(Request $request)
    {
        try {
            //update status
            $lembur = DB::table('lembur')->where('id',$request->id)->update(['status'=>'rejected']);
            return $this->respond($lembur);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function getDetailApproval($id)
    {
        try {
            $data = $this->approvalService->getDetailApproval($id);

            $result = new ApprovalDetailResource($data);
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function approveApproval($id, ApproveApprovalRequest $request)
    {
        try {
            $data = $this->approvalService->approveApproval($id, $request);

            $result = new ApproveApprovalResource($data);
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function rejectApproval($id, RejectApprovalRequest $request)
    {
        try {
            $data = $this->approvalService->rejectApproval($id, $request);

            $result = new RejectApprovalResource($data);
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }
}
