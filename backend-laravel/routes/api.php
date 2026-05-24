<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PaymentController;

Route::post('/payment', [PaymentController::class, 'createPayment']);

Route::post('/payment/{id}/confirm', [PaymentController::class, 'confirmPayment']);

Route::get('/transactions', [PaymentController::class, 'getTransactions']);