<?php

use App\Http\Controllers\Project\ProjectController;


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
        Route::get('get-data', 'getData')->name('getdata');
        Route::get('get-data-employ', 'getDataEmploy')->name('getdataemploy');
    });
});
