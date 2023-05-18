<?php

use App\Http\Controllers\Api\V1\Approval\ApprovalController;

/*
|--------------------------------------------------------------------------
| Approval API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register approval related routes for your application.
|
*/


Route::controller(ApprovalController::class)->group(function () {
    Route::get('approvals', 'getApprovalData');
    //make route get lembur data
    Route::get('lemburs', 'getLemburData');
    //make route approve lembur
    Route::post('lemburs/approve', 'approveLembur');
    //make route reject lembur
    //add route add lembur
    Route::post('lemburs/add', 'addLembur');
    Route::post('lemburs/reject', 'rejectLembur');
    Route::get('approvals/{id}', 'getDetailApproval');
    Route::put('approvals/{id}/approve', 'approveApproval');
    Route::put('approvals/{id}/reject', 'rejectApproval');
});
