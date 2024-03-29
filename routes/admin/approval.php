<?php

use App\Http\Controllers\Approval\ApprovalController;


/*
|--------------------------------------------------------------------------
| Approval Routes
|--------------------------------------------------------------------------
|
| Here is where you can register setting related routes for your application.
|
*/



Route::prefix('approval')->name('approval.')->group(function () {
    Route::controller(ApprovalController::class)->group(function () {
        Route::get('/', 'index')->name('index');
        Route::get('get-data', 'getData')->name('getdata');
        Route::get('get-lembur', 'getLembur')->name('getlembur');
        Route::post('post-lembur', 'updateStatusLembur')->name('updateStatusLembur');
        Route::put('{id}/approve', 'approveApproval')->name('approve');
        Route::put('{id}/reject', 'rejectApproval')->name('reject');

        Route::get('/lembur-export', 'exportTemplate')->name('lemburexport');
        Route::post('/lembur-import', 'importLembur')->name('lemburimport');
    });
});
