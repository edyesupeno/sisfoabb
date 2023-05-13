<?php

namespace App\Http\Controllers\Project;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Services\Approval\ApprovalService;
use App\Http\Controllers\AdminBaseController;
use App\Http\Requests\Approval\RejectApprovalRequest;
use App\Http\Resources\Approval\ApprovalListResource;
use App\Http\Resources\Approval\SubmitApprovalResource;

class ProjectController extends AdminBaseController
{
    public function __construct(
        ApprovalService $approvalService,
    ) {
        $this->approvalService = $approvalService;
        
        $this->title = "ERP ABB | Project";
        $this->path = "project/index";
        $this->data = [];
    }

    public function getData(Request $request)
    {
        try {
            $project = DB::table('branches')->select('branches.*','users.id as iduser','users.name as nameuser')->join('users', 'users.id', '=', 'branches.manager')->whereNull('branches.deleted_at')->paginate(10);
            
            return $this->respond($project);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }
    //get data area by branch id and pleton by id area
    public function getDataArea(Request $request)
    {
        try {
            $project = DB::table('area')->select('area.*')->where('area.id_branch',$request->id)->whereNull('area.deleted_at')->paginate(10);
            //foreach project 
            foreach($project as $key => $value){
                $pleton = DB::table('pleton')->select('pleton.*')->where('pleton.id_area',$value->id)->whereNull('pleton.deleted_at')->get();
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
            $project = DB::table('users')->select('users.name','users.id')->get();
            
            return $this->respond($project);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }
}
