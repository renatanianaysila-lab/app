<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\MateriController;

Route::get('/materi', [MateriController::class, 'index']);


Route::post('/payment', [PaymentController::class, 'createPayment']);
Route::post('/payment/{id}/confirm', [PaymentController::class, 'confirmPayment']);
Route::get('/transactions', [PaymentController::class, 'getTransactions']);


Route::post('/register/murid', [UserController::class, 'registerMurid']);
Route::post('/login', [UserController::class, 'login']);


Route::get('/forum', function () {
    return response()->json([
        'success' => true,
        'message' => 'Daftar diskusi forum berhasil diambil',
        'data' => \Illuminate\Support\Facades\DB::table('forums')->get()
    ], 200);
});

Route::get('/quiz', function () {
    return response()->json([
        'success' => true,
        'message' => 'Daftar soal kuis berhasil diambil',
        'data' => \Illuminate\Support\Facades\DB::table('quizzes')->get()
    ], 200);
});

Route::get('/packages', function () {
    return response()->json([
        'success' => true,
        'message' => 'Daftar paket premium berhasil diambil',
        'data' => \Illuminate\Support\Facades\DB::table('packages')->get()
    ], 200);
});