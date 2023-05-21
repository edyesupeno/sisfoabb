<?php

namespace App\Http\Controllers\Api\V1\Approval;

use Illuminate\Http\Request;
use App\Http\Controllers\ApiBaseController;
use App\Services\Api\V1\Approval\ApprovalService;
use Illuminate\Support\Facades\DB;
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
            //get lembur from db
            $result = new ApprovalListResource($data);
           
            return $this->respond($result);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function getLemburData($id,$status)
    {
        try {
            //get lembur query join with user and branch where id branch = id branch rquest and status
            $lembur = DB::table('lembur')->select('lembur.*','lembur.tanggal as created_at','users.name as created_by','branches.name as branch')->join('users', 'users.id', '=', 'lembur.id_employee')->join('branches', 'branches.id', '=', 'lembur.id_branch')->where('lembur.id_branch',$id)->where('lembur.status',$status)->whereNull('lembur.deleted_at')->get();
            //get attendance by id user and created_by in lemburs
            $attedance = DB::table('attendance')->where('id_user',$id)->where('created_by',$lembur[0]->created_by)->get();
            //merge
            $data = array();
            $data['attendance'] = $attedance;
            $data['lembur'] = $lembur;

             return $this->respond($data);
         } catch (\Exception $e) {
             return $this->exceptionError($e->getMessage());
         }
    }

    public function getLemburDataManager($id,$status,$page,$datestart,$dateend,$sort)
    {
        try {
            //get all lembur status awaiting
            $lembur = DB::table('lembur')->select('lembur.*','lembur.tanggal as created_at','users.name as created_by','branches.name as branch')->join('users', 'users.id', '=', 'lembur.id_employee')->join('branches', 'branches.id', '=', 'lembur.id_branch')->where('lembur.status',$status)->whereNull('lembur.deleted_at')->get();
            //foreach $lembur
            $data = array();
            $cek = '';
            $id = DB::table('employees')->select('id')->where('user_id',$id)->get();
            foreach ($lembur as $key => $l) {
              //get user id
                $id_user = $l->id_employee;
                //get employee  and get column manager
                $manager = DB::table('employees')->select('manager_id')->where('user_id',$id_user)->get();
                
                //get manager id in employee b
                
               
                //if manager == id
                if ($manager[0]->manager_id == $id[0]->id) {
                    $jam_masuk = $l->jam_masuk;
                $jam_keluar = $l->jam_keluar;
                //split jam masuk and jam keluar
                $jam_masuk = explode(':',$jam_masuk);
                $jam_keluar = explode(':',$jam_keluar);
                //between array 0 to int
                $jam_masuk = (int)$jam_masuk[0];
                $jam_keluar = (int)$jam_keluar[0];
                //if jam masuk > jam keluar
                if ($jam_masuk > $jam_keluar) {
                  //jam keluar + 24
                  $jam_keluar = $jam_keluar + 24;
                }
                //count between
                $between = $jam_keluar - $jam_masuk;
                $l->between = $between;
                
                    //edit $data jam_masuk and jam_keluar
                    $l->jam_masuk = date('H:i',strtotime($l->jam_masuk));
                    $l->jam_keluar = date('H:i',strtotime($l->jam_keluar));
                    
                    //add $l to $data
                    array_push($data,$l);
              
                }
            }
            if ($sort == "asc") {
                //if $data > 1
                if (count($data) > 1) {
                    //sort $data by between
                    usort($data, function($a, $b) {
                        return $a->between <=> $b->between;
                    });
                }
                
            }
            if ($sort == "desc") {
                //if $data > 1
                if (count($data) > 1) {
                    //sort $data by between
                    usort($data, function($a, $b) {
                        return $b->between <=> $a->between;
                    });
                }
            }
            if ($datestart != "no" && $dateend != "no") {
                //filter date
                $data = array_filter($data, function($item) use($datestart,$dateend) {
                    return $item->tanggal >= $datestart && $item->tanggal <= $dateend;
                });
            }
            if ($data == null) {
               //push kosong
                array_push($data,['count' => 0]);
            }

             return $this->respond($data);
         } catch (\Exception $e) {
             return $this->exceptionError($e->getMessage());
         }
    }
    public function getDetailLembur($id)
    {
        try {
            //get lembur by id
            $lembur = DB::table('lembur')->select('lembur.*','lembur.tanggal as created_at','users.name as created_by','branches.name as branch')->join('users', 'users.id', '=', 'lembur.id_employee')->join('branches', 'branches.id', '=', 'lembur.id_branch')->where('lembur.id',$id)->whereNull('lembur.deleted_at')->get();
          
             return $this->respond($lembur);
         } catch (\Exception $e) {
             return $this->exceptionError($e->getMessage());
         }
    }
    //getlemburby id user
    public function getLemburDataById($id,$status)
    {
        try {
            //get lembur query join with user and branch where id branch = id branch rquest and status
            $lembur = DB::table('lembur')->select('lembur.*','lembur.id as idlembur','lembur.tanggal as created_at','users.name as created_by','branches.name as branch')->join('users', 'users.id', '=', 'lembur.id_employee')->join('branches', 'branches.id', '=', 'lembur.id_branch')->where('lembur.id_employee',$id)->where('lembur.status',$status)->whereNull('lembur.deleted_at')->get();
              //make datenya now to datetime
        
              $attedance = DB::table('attendances')->where('user_id',$id)->get();
              //if attendance in created_at and datenow
              //make created_at to date
              $data = array();
              //foreach attendance
              //foreach lembur
              foreach ($lembur as $key => $l) {
                //get jam masuk and jam keluar
                $jam_masuk = $l->jam_masuk;
                $jam_keluar = $l->jam_keluar;
                //split jam masuk and jam keluar
                $jam_masuk = explode(':',$jam_masuk);
                $jam_keluar = explode(':',$jam_keluar);
                //between array 0 to int
                $jam_masuk = (int)$jam_masuk[0];
                $jam_keluar = (int)$jam_keluar[0];
                //if jam masuk > jam keluar
                if ($jam_masuk > $jam_keluar) {
                  //jam keluar + 24
                  $jam_keluar = $jam_keluar + 24;
                }
                //count between
                $between = $jam_keluar - $jam_masuk;
                
                //add to data
                $data['between'][] = $between;

                foreach ($attedance as $key => $value) {
                    $datenya = date('Y-m-d',strtotime($value->created_at));
                    $datelembur = date('Y-m-d',strtotime($l->created_at));
                  if ($datenya== $datelembur) {
                    $data['attendance'] = $value;
                  }
                  }
                }
             
              
              //make array
              
              //make array attendance
           
              //make array lembur
              $data['lembur'] = $lembur; 
            return $this->respond($data);
         } catch (\Exception $e) {
             return $this->exceptionError($e->getMessage());
         }
    }
    //update deleted_at lembur
    public function deleteLembur(Request $request)
    {
        try {
            //update deleted_at lembur
            $lembur = DB::table('lembur')->where('id',$request->id)->update(['deleted_at'=>date('Y-m-d H:i:s')]);
            //make array success
            // $res = array();
            // $res['success'] = true;
            //return
            $a = 'success';
            return $this->respond($a);
         } catch (\Exception $e) {
             return $this->exceptionError($e->getMessage());
         }
    }
    public function p()
    {
        try {
            //update deleted_at lembur
            // $lembur = DB::table('lembur')->where('id',$id)->update(['deleted_at'=>date('Y-m-d H:i:s')]);
            //make array success
            // $res = array();
            // $res['success'] = true;
            //return
            $a = 'success';
            return $this->respond($a);
         } catch (\Exception $e) {
             return $this->exceptionError($e->getMessage());
         }
    }

    //add lembur
    public function addLembur(Request $request)
    {
        try {
            //insert lembur
            //cek if employee id attendanve now with date_clock column and  clock_in and clock_out is not null and count 
            $cek = DB::table('attendances')->where('user_id',$request->id)->where('date_clock',date('Y-m-d'))->whereNotNull('clock_in')->whereNotNull('clock_out')->get();
            //get employees
            $employee = DB::table('employees')->where('user_id',$request->id)->get();
            //foreach employee
            $id_branch = '';
            foreach ($employee as $key => $value) {
                //get id branch
                $id_branch = $value->id_branch;
            }
           
            // if($cek->count() > 0){
                //datetime now
                $now = date('Y-m-d H:i:s');
                $lembur = DB::table('lembur')->insert(['type'=>'Approval Lembur','jam_masuk'=>$request->waktu_masuk,'jam_keluar'=>$request->waktu_keluar,'id_employee'=>$request->id_employee,'id_branch'=> $id_branch,'keterangan'=>$request->keterangan,'tanggal'=>$now,'lembur'=>$request->tanggal,'status'=>'awaiting']);
                $a = 'success';
                return $this->respond($a);
            // }else{
            //     return $this->respond(date('Y-m-d'));
            // }
            
            
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    //approve lembur
    public function approveLembur(Request $request)
    {
        try {
            //update waktu_masuk and waktu_keluar and status to approve
            $lembur = DB::table('lembur')->where('id',$request->id)->update(['jam_masuk'=>$request->waktu_masuk,'jam_keluar'=>$request->waktu_keluar,'status'=>'approved']);
            return $this->respond('success');
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }
    //get lembut lenght
    public function getapprovalLength($id)
    {
        try {
            //get lembur and approval
            $lembur = DB::table('lembur')->where('id_employee',$id)->where('status','awaiting')->get();
            //count
            $a = $lembur->count();
            //get approval awating
            $approval = DB::table('approval')->where('id_employee',$id)->where('status','awaiting')->get();
            //count
            $b = $approval->count();
            return $this->respond($a);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }
    //reject lembur
    public function rejectLembur(Request $request)
    {
        try {
            //update status and reason
            $lembur = DB::table('lembur')->where('id',$request->id)->update(['status'=>'rejected','reason'=>$request->reason]);
            return $this->respond('success');
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
