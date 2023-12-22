<?php

use App\Http\Controllers\BookingBajuController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\RequestIzinKeluarController;
use App\Http\Controllers\RequestIzinBermalamController;
use App\Http\Controllers\RuanganController;
use App\Http\Controllers\RequestSuratController;
use App\Http\Controllers\BookingRuanganController;


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/
Route::post('/register',[AuthController::class,'register']);
Route::post('/login',[AuthController::class,'login']);

Route::group(['middleware'=>['auth:sanctum']],function(){

    Route::get('/user',[RequestIzinKeluarController::class, 'user']);
    Route::post('/logout',[RequestIzinKeluarController::class, 'logout']);


    //Izin_Bermalam
    Route::get('/izinbermalam',[RequestIzinBermalamController::class, 'index']);
    Route::post('/izinbermalam',[RequestIzinBermalamController::class, 'store']);
    Route::put('/izinbermalam/{id}',[RequestIzinBermalamController::class, 'update']);
    Route::get('/izinbermalam/{id}',[RequestIzinBermalamController::class, 'show']);
    Route::delete('/izinbermalam/{id}',[RequestIzinBermalamController::class, 'destroy']);


    //Izin_Keluar
    Route::get('/izinkeluar',[RequestIzinKeluarController::class, 'index']);
    Route::post('/izinkeluar',[RequestIzinKeluarController::class, 'store']);
    Route::put('/izinkeluar/{id}',[RequestIzinKeluarController::class, 'update']);
    Route::get('/izinkeluar/{id}',[RequestIzinKeluarController::class, 'show']);
    Route::delete('/izinkeluar/{id}',[RequestIzinKeluarController::class, 'destroy']);

     //Izin_Surat
     Route::get('/surat',[RequestSuratController::class, 'index']);
     Route::post('/surat',[RequestSuratController::class, 'store']);
     Route::put('/surat/{id}',[RequestSuratController::class, 'update']);
     Route::get('/surat/{id}',[RequestSuratController::class, 'show']);
     Route::delete('/surat/{id}',[RequestSuratController::class, 'destroy']);

    //Booking_Ruangan
    Route::get('/booking-ruangan', [BookingRuanganController::class, 'index']);
    Route::post('/booking-ruangan', [BookingRuanganController::class, 'bookRoom']);
    Route::delete('/booking-ruangan/{id}', [BookingRuanganController::class, 'destroy']);
    Route::get('/ruangan', [RuanganController::class, 'index']);

    Route::get('/bookingbaju',[BookingBajuController::class, 'index']);
    Route::post('/bookingbaju',[BookingBajuController::class, 'store']);
    Route::put('/bookingbaju/{id}',[BookingBajuController::class, 'update']);
    Route::get('/bookingbaju/{id}',[BookingBajuController::class, 'show']);
    Route::delete('/bookingbaju/{id}',[BookingBajuController::class, 'destroy']);

    Route::get('/ukuran-baju', [BookingBajuController::class, 'getBaju']);

    Route::get('/izin-keluar/all', [RequestIzinKeluarController::class, 'viewAllRequestsForBaak']);
    Route::put('/izin-keluar/{id}/approve', [RequestIzinKeluarController::class, 'approveIzinKeluar']);
    Route::put('/izin-keluar/{id}/reject', [RequestIzinKeluarController::class, 'rejectIzinKeluar']);



    Route::get('/izin-bermalam/all', [RequestIzinBermalamController::class, 'viewAllRequestsForBaak']);
    Route::put('/izin-bermalam/{id}/approve', [RequestIzinBermalamController::class, 'approveIzinBermalam']);
    Route::put('/izin-bermalam/{id}/reject', [RequestIzinBermalamController::class, 'rejectIzinBermalam']);


    Route::get('/izin-surat/all', [RequestSuratController::class, 'viewAllRequestsForBaak']);
    Route::put('/izin-surat/{id}/approve', [RequestSuratController::class, 'approveIzinSurat']);
    Route::put('/izin-surat/{id}/reject', [RequestSuratController::class, 'rejectIzinSurat']);

    Route::get('/booking-ruangan/all', [BookingRuanganController::class, 'viewAllRequestsForBaak']);
    Route::put('/booking-ruangan/{id}/approve', [BookingRuanganController::class, 'approveBookingRuangan']);
    Route::put('/booking-ruangan/{id}/reject', [BookingRuanganController::class, 'rejectBookingRuangan']);

    Route::get('/booking-baju/all', [BookingBajuController::class, 'viewAllRequestsForBaak']);
    Route::put('/booking-baju/{id}/approve', [BookingBajuController::class, 'approveBookingBaju']);
    Route::put('/booking-baju/{id}/reject', [BookingBajuController::class, 'rejectBookingBaju']);

});