<?php

use App\Actions\Utility\Attendance\CheckStatusAttendance;
use App\Actions\Utility\GetFile;
use App\Actions\Utility\Leave\GenerateLeavePeriod;
use App\Helpers\Utility\Time;
use App\Http\Controllers\Attendance\Attendance\AttendanceDailyController;
use App\Http\Controllers\Attendance\Schedule\ScheduleController;
use App\Http\Controllers\Attendance\Shift\ShiftController;
use App\Http\Controllers\Attendance\Attendance\AttendanceOverviewController;
use App\Models\Attendance;
use App\Models\BreakTime;
use App\Models\Employee;
use App\Models\Leave;
use App\Models\Schedule;
use Carbon\Carbon;
use Carbon\CarbonPeriod;

/*
|--------------------------------------------------------------------------
| Attendance Routes
|--------------------------------------------------------------------------
|
| Here is where you can register setting related routes for your application.
|
*/



Route::prefix('attendance')->name('attendance.')->group(function () {
    Route::controller(ShiftController::class)->prefix('shift')->name('shift.')->group(function () {
        Route::get('/', 'getShiftIndex')->name('index');
        Route::get('get-data', 'getShiftList')->name('getdata');
        Route::post('create-data', 'createShift')->name('create');
        Route::put('{id}/update-data', 'editShift')->name('update');
        Route::delete('{id}/delete-data', 'deleteShift')->name('delete');
    });

    Route::controller(AttendanceOverviewController::class)->prefix('attendance')->name('attendance-overview.')->group(function () {
        Route::get('/', 'index')->name('index');
        Route::get('get-attendance-header', 'getAttendanceListDate')->name('getattendanceheader');
        Route::get('get-data', 'getAttendanceList')->name('getdata');
        Route::get('get-attendance-recap', 'getAttendanceRecap')->name('getdatarecap');
        Route::get('get-attendance-overview', 'getAttendanceOverviewData')->name('getdataoverview');
        Route::get('export-attendance-monthly', 'getAttendanceListExport')->name('exportAttendanceMonthly');
        Route::get('export-attendance-monthly-template', 'exportAttendanceMonthlyTemplate')->name('exportAttendanceMonthlyTemplate');
        Route::post('import-attendance-monthly', 'importAttendanceMonthly')->name('importAttendanceMonthly');
    });

    Route::controller(AttendanceDailyController::class)->prefix('attendance-daily')->name('attendance-daily.')->group(function () {
        Route::get('/', 'index')->name('index');
        Route::get('get-attendance-header', 'getAttendanceListDate')->name('getattendanceheader');
        Route::get('get-data', 'getAttendanceList')->name('getdata');
        Route::get('get-attendance-recap', 'getAttendanceRecap')->name('getdatarecap');
        Route::get('get-attendance-overview', 'getAttendanceOverviewData')->name('getdataoverview');
        Route::get('export-attendance-monthly', 'getAttendanceListExport')->name('exportAttendanceMonthly');
        Route::get('export-attendance-monthly-template', 'exportAttendanceMonthlyTemplate')->name('exportAttendanceMonthlyTemplate');
        Route::post('import-attendance-monthly', 'importAttendanceMonthly')->name('importAttendanceMonthly');
    });
});

Route::prefix('attendance')->name('attendance.')->group(function () {
    Route::controller(ScheduleController::class)->prefix('schedule')->name('schedule.')->group(function () {
        Route::get('/', 'getScheduleIndex')->name('index');
        Route::get('get-data', 'getSchedule')->name('getdata');
        Route::get('get-shift-options', 'getShiftOptions')->name('getshiftOptions');
        Route::get('get-report', 'getReport')->name('getreport');
        Route::get('{branch_id}/get-group-by-branch', 'getGroupByBranch')->name('getGroupByBranch');
        Route::get('{branch_id}/get-employee-by-branch', 'getEmployeeByBranch')->name('getEmployeeByBranch');
        Route::post('create-bulk-schedule', 'bulkStore')->name('createBulk');
        Route::post('{user_id}/update-schedule', 'updateSchedule')->name('update');
        // Route::put('{id}/update-data', 'editShift')->name('update');
        // Route::delete('{id}/delete-data', 'deleteShift')->name('delete');

        Route::get('/schedule-export', 'exportTemplate')->name('scheduleexport');
        Route::post('/schedule-import', 'importSchedule')->name('scheduleimport');
    });
});
