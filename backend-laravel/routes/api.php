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

// Ambil semua riwayat skor kuis untuk ditampilkan di riwayat_page.dart (GET)
Route::get('/quiz/history', function () {
    return response()->json([
        'success' => true,
        'message' => 'Semua riwayat nilai kuis berhasil diambil',
        'data' => \Illuminate\Support\Facades\DB::table('quiz_scores')
            ->orderBy('created_at', 'desc')
            ->get()
    ], 200);
});

// --- RUTE PAKET PREMIUM ---
Route::get('/packages', function () {
    return response()->json([
        'success' => true,
        'message' => 'Daftar paket premium berhasil diambil',
        'data' => \Illuminate\Support\Facades\DB::table('packages')->get()
    ], 200);
}); 

// 1. Ambil status langganan aktif pengguna (GET)
Route::get('/user/subscription/{user_id}', function ($user_id) {
    $subscription = \Illuminate\Support\Facades\DB::table('user_subscriptions')
        ->where('user_id', $user_id)
        ->where('status', 'active')
        ->first();

    return response()->json([
        'success' => true,
        'message' => 'Status langganan berhasil dimuat',
        'is_premium' => $subscription ? true : false,
        'data' => $subscription
    ], 200);
});

// 2. Ambil progress tontonan materi video murid (GET)
Route::get('/user/progress/{user_id}', function ($user_id) {
    $progress = \Illuminate\Support\Facades\DB::table('user_progress')
        ->where('user_id', $user_id)
        ->get();

    return response()->json([
        'success' => true,
        'message' => 'Progress belajar berhasil diambil',
        'data' => $progress
    ], 200);
});