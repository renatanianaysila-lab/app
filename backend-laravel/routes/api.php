<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\MateriController;

// Rute Materi
Route::get('/materi', [MateriController::class, 'index']);

// Rute Pembayaran & Transaksi
Route::post('/payment', [PaymentController::class, 'createPayment']);
Route::post('/payment/{id}/confirm', [PaymentController::class, 'confirmPayment']);
Route::get('/transactions', [PaymentController::class, 'getTransactions']);

// Rute Autentikasi User
Route::post('/register/murid', [UserController::class, 'registerMurid']);
Route::post('/login', [UserController::class, 'login']);

// --- RUTE FORUM ---
// 1. Ambil data forum (GET)
Route::get('/forum', function () {
    return response()->json([
        'success' => true,
        'message' => 'Daftar diskusi forum berhasil diambil',
        'data' => \Illuminate\Support\Facades\DB::table('forums')->get()
    ], 200);
});

// 2. Kirim data forum baru (POST)
Route::post('/forum', function (\Illuminate\Http\Request $request) {
    // Validasi data inputan
    $validated = $request->validate([
        'judul' => 'required|string|max:255',
        'konten' => 'required|string',
        'pembuat' => 'required|string|max:255',
    ]);

    // Masukkan data ke database
    $id = \Illuminate\Support\Facades\DB::table('forums')->insertGetId([
        'judul' => $validated['judul'],
        'konten' => $validated['konten'],
        'pembuat' => $validated['pembuat'],
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    return response()->json([
        'success' => true,
        'message' => 'Pertanyaan forum berhasil ditambahkan!',
        'data' => \Illuminate\Support\Facades\DB::table('forums')->where('id', $id)->first()
    ], 201);
});

// --- RUTE KUIS ---
// 1. Ambil bank soal kuis (GET)
Route::get('/quiz', function () {
    return response()->json([
        'success' => true,
        'message' => 'Daftar soal kuis berhasil diambil',
        'data' => \Illuminate\Support\Facades\DB::table('quizzes')->get()
    ], 200);
});

// 2. Kirim hasil skor kuis murid langsung ke database MySQL (POST)
Route::post('/quiz/score', function (\Illuminate\Http\Request $request) {
    // Validasi input dari aplikasi mobile
    $validated = $request->validate([
        'user_id' => 'required|integer',
        'level' => 'required|string',
        'skor' => 'required|integer',
    ]);

    // Masukkan data nyata ke tabel quiz_scores di database
    $id = \Illuminate\Support\Facades\DB::table('quiz_scores')->insertGetId([
        'user_id' => $validated['user_id'],
        'level' => $validated['level'],
        'skor' => $validated['skor'],
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    return response()->json([
        'success' => true,
        'message' => 'Skor kuis berhasil disimpan ke database!',
        'data' => \Illuminate\Support\Facades\DB::table('quiz_scores')->where('id', $id)->first()
    ], 201);
});

// --- RUTE PAKET PREMIUM ---
Route::get('/packages', function () {
    return response()->json([
        'success' => true,
        'message' => 'Daftar paket premium berhasil diambil',
        'data' => \Illuminate\Support\Facades\DB::table('packages')->get()
    ], 200);
}); 