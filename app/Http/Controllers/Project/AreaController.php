<?php

namespace App\Http\Controllers\Project;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Services\Approval\ApprovalService;
use App\Http\Controllers\AdminBaseController;
use App\Http\Requests\Approval\RejectApprovalRequest;
use App\Http\Resources\Approval\ApprovalListResource;
use App\Http\Resources\Approval\SubmitApprovalResource;

class AreaController extends AdminBaseController
{
    public function __construct(Request $request
    ) {
        
        $this->title = "ERP ABB | Area";
        $this->path = "project/Pleton";
        $this->data = [];
        $this->id = $request->route()->parameter('id');
    }

    public function addData(Request $request)
    {
       //add by request area to  db
        try {
            $project = DB::table('area')->insert([
                'nama' => $request->name,
                'id_branch' => $request->id,
            ]);
            //and add pleton to area last insert id
            $pleton = DB::table('pleton')->insert([
                'nama' => $request->pleton,
                'id_area' => DB::getPdo()->lastInsertId(),
            ]);
            return $this->respond($project);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    public function addPleton(Request $request)
    {
       //add by request area to  db
        try {
         
            //and add pleton to area last insert id
            $pleton = DB::table('pleton')->insert([
                'nama' => $request->pleton,
                'id_area' =>$request->id,
            ]);
            return $this->respond($pleton);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    //updatedata
    public function updateData(Request $request)
    {
        try {
            $project = DB::table('area')->where('id',$request->id)->update([
                'nama' => $request->name,
                'id_branch' => $request->id_branch,
            ]);
            //and add pleton to area last insert id
            $pleton = DB::table('pleton')->where('id',$request->pleton_id)->update([
                'nama' => $request->pleton,
                'id_area' => $request->id,
            ]);
            return $this->respond($project);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }

    //delete data
    public function deleteData(Request $request)
    {
        try {
            $project = DB::table('area')->where('id',$request->id)->delete();
            return $this->respond($project);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }
    //get data area by branch id and pleton by id area
    public function getDataArea(Request $request)
    {
        try {
            $project = DB::table('areas')->select('areas.*')->where('areas.branch_id',$request->branch_id)->whereNull('areas.deleted_at')->paginate(10);
            //foreach project 
            foreach($project as $key => $value){
                $pleton = DB::table('pletons')->select('pletons.*')->where('pletons.area_id',$value->id)->whereNull('pletons.deleted_at')->get();
                $project[$key]->pleton = $pleton;
            }
            //send success
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
