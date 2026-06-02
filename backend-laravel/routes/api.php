<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\MateriController;

Route::get('/materi', [MateriController::class, 'index']);

// Route Payment yang sudah ada sebelumnya
Route::post('/payment', [PaymentController::class, 'createPayment']);
Route::post('/payment/{id}/confirm', [PaymentController::class, 'confirmPayment']);
Route::get('/transactions', [PaymentController::class, 'getTransactions']);

// Tambahan Route untuk Registrasi dan Login IsyaratKita
Route::post('/register/murid', [UserController::class, 'registerMurid']);
Route::post('/login', [UserController::class, 'login']);
Route::get('/forum', [App\Http\Controllers\ForumController::class, 'index']);

