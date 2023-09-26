<?php

use App\Http\Controllers\Project\ProjectController;
use App\Http\Controllers\Project\AreaController;
use App\Http\Controllers\Project\OrganisasiController;

/*
|--------------------------------------------------------------------------
| Approval Routes
|--------------------------------------------------------------------------
|
| Here is where you can register setting related routes for your application.
|
*/



Route::prefix('project')->name('project.')->group(function () {
    Route::controller(ProjectController::class)->group(function () {
        Route::get('/', 'index')->name('index');
        Route::get('detail', 'detail')->name('detail');
        Route::get('get-data-area', 'getDataArea')->name('getDataArea');
        Route::get('get-data', 'getData')->name('getdata');
        Route::get('get-all-data', 'getAllData')->name('getalldata');
        Route::get('get-data-employ', 'getDataEmploy')->name('getdataemploy');
    });
   
});
Route::prefix('area')->name('area.')->group(function () {
    Route::controller(AreaController::class)->group(function () {
        //route get index and send id project
        Route::get('/{id}', 'index')->name('index');
        Route::post('deleteData', 'deleteData')->name('deleteData');
        Route::post('addData', 'addData')->name('addData');
        Route::post('addPleton', 'addPleton')->name('addPleton');
        Route::post('updateData', 'updateData')->name('updateData');
    });
});

Route::prefix('organisasi')->name('organisasi.')->group(function () {
    Route::controller(OrganisasiController::class)->group(function () {
        //route get index and send id project
        Route::get('/{id}', 'index')->name('index');
        Route::post('get-data-employ', 'getDataEmploy')->name('getdataemploy');
        Route::post('getDataShift', 'getDataShift')->name('getDataShift');
        Route::post('addOrganisasi', 'addOrganisasi')->name('addOrganisasi');
        Route::post('deleteData', 'deleteData')->name('deleteData');
        Route::post('addData', 'addData')->name('addData');
        Route::post('addPleton', 'addPleton')->name('addPleton');
        Route::post('updateData', 'updateData')->name('updateData');
    });
});
