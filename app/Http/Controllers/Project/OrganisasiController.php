<?php

namespace App\Http\Controllers\Project;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Services\Approval\ApprovalService;
use App\Http\Controllers\AdminBaseController;
use App\Http\Requests\Approval\RejectApprovalRequest;
use App\Http\Resources\Approval\ApprovalListResource;
use App\Http\Resources\Approval\SubmitApprovalResource;

class OrganisasiController extends AdminBaseController
{
    public function __construct(Request $request
    ) {
        
        $this->title = "ERP ABB | Organisasi";
        $this->path = "project/organisasi";
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
       //get data employees where branch id inner join with desination in key designation_id and designations.id and user
        try {
            $project = DB::table('employees')->select('employees.*','designations.name as designation_name','users.name as user_name')->join('designations','designations.id','=','employees.designation_id')->join('users','users.id','=','employees.user_id')->where('employees.branch_id',$request->branch_id)->whereNull('employees.deleted_at')->paginate(10);
            //send success
            return $this->respond($project);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }
    //get shift by idbranch
    public function getDataShift(Request $request)
    {
        try {
            $project = DB::table('shifts')->select('shifts.*')->where('shifts.branch_id',$request->branch_id)->whereNull('shifts.deleted_at')->paginate(10);
            //send success
            return $this->respond($project);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }
    //edit employees area pleton dan schedule named addOrganisasi
    public function addOrganisasi(Request $request)
    {
        try {
            //update employees
            $project = DB::table('employees')->where('id',$request->id)->update([
                'area' => $request->area,
                'pleton' => $request->pleton,
                'schedule' => $request->schedule,
            ]);
            //send success
            return $this->respond($project);
        } catch (\Exception $e) {
            return $this->exceptionError($e->getMessage());
        }
    }
}
