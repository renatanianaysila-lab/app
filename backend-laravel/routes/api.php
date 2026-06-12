<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\MateriController;
use App\Http\Controllers\QuizController;

// Rute Materi (Siswa)
Route::get('/materi', [MateriController::class, 'index']);

// Rute Pembayaran & Transaksi
Route::post('/payment', [PaymentController::class, 'createPayment']);
Route::post('/payment/{id}/confirm', [PaymentController::class, 'confirmPayment']);
Route::get('/transactions', [PaymentController::class, 'getTransactions']);

// Rute Autentikasi User
Route::post('/register/murid', [UserController::class, 'registerMurid']);
Route::post('/login', [UserController::class, 'login']);

// --- RUTE FORUM ---
Route::get('/forum', function () {
    return response()->json([
        'success' => true,
        'message' => 'Daftar diskusi forum berhasil diambil',
        'data' => DB::table('forums')->get()
    ], 200);
});

Route::post('/forum', function (Request $request) {
    $validated = $request->validate([
        'judul' => 'required|string|max:255',
        'konten' => 'required|string',
        'pembuat' => 'required|string|max:255',
    ]);

    $id = DB::table('forums')->insertGetId([
        'judul' => $validated['judul'],
        'konten' => $validated['konten'],
        'pembuat' => $validated['pembuat'],
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    return response()->json([
        'success' => true,
        'message' => 'Pertanyaan forum berhasil ditambahkan!',
        'data' => DB::table('forums')->where('id', $id)->first()
    ], 201);
});

// --- RUTE KUIS ---
Route::get('/quiz', function () {
    return response()->json([
        'success' => true,
        'message' => 'Daftar soal kuis berhasil diambil',
        'data' => DB::table('quizzes')->get()
    ], 200);
});

Route::get('/quizzes/{kategori}', [QuizController::class, 'index']);

Route::post('/quiz/score', function (Request $request) {
    $validated = $request->validate([
        'user_id' => 'required|integer',
        'level' => 'required|string',
        'skor' => 'required|integer',
    ]);

    $id = DB::table('quiz_scores')->insertGetId([
        'user_id' => $validated['user_id'],
        'level' => $validated['level'],
        'skor' => $validated['skor'],
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    return response()->json([
        'success' => true,
        'message' => 'Skor kuis berhasil disimpan ke database!',
        'data' => DB::table('quiz_scores')->where('id', $id)->first()
    ], 201);
});

Route::get('/quiz/history', function () {
    return response()->json([
        'success' => true,
        'message' => 'Semua riwayat nilai kuis berhasil diambil',
        'data' => DB::table('quiz_scores')->orderBy('created_at', 'desc')->get()
    ], 200);
});

// --- RUTE PAKET PREMIUM ---
Route::get('/packages', function () {
    return response()->json([
        'success' => true,
        'message' => 'Daftar paket premium berhasil diambil',
        'data' => DB::table('packages')->get()
    ], 200);
}); 

Route::get('/user/subscription/{user_id}', function ($user_id) {
    $subscription = DB::table('user_subscriptions')
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

Route::get('/user/progress/{user_id}', function ($user_id) {
    $progress = DB::table('user_progress')
        ->where('user_id', $user_id)
        ->get();

    return response()->json([
        'success' => true,
        'message' => 'Progress belajar berhasil diambil',
        'data' => $progress
    ], 200);
});

// ─── FITUR INPUT SISI ADMIN (Untuk Tombol Tambah Modul, Kategori, Guru) ───

// 1. Tambah Materi Baru ke tabel materis
Route::post('/admin/materi', function (Request $request) {
    $validated = $request->validate([
        'judul' => 'required|string|max:255',
        'kategori' => 'required|string|max:50',
        'deskripsi' => 'required|string',
        'video_url' => 'required|url',
    ]);

    $id = DB::table('materis')->insertGetId([
        'judul' => $validated['judul'],
        'kategori' => $validated['kategori'],
        'deskripsi' => $validated['deskripsi'],
        'video_url' => $validated['video_url'],
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    return response()->json([
        'success' => true,
        'message' => 'Materi video berhasil ditambahkan oleh Admin!',
        'data' => DB::table('materis')->where('id', $id)->first()
    ], 201);
});

// 2. Tambah Kategori Baru ke tabel categories
Route::post('/admin/kategori', function (Request $request) {
    $validated = $request->validate([
        'nama_kategori' => 'required|string|max:100',
    ]);

    $id = DB::table('categories')->insertGetId([
        'nama_kategori' => $validated['nama_kategori'],
        'slug' => strtolower(str_replace(' ', '-', $validated['nama_kategori'])),
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    return response()->json([
        'success' => true,
        'message' => 'Kategori baru berhasil ditambahkan oleh Admin!',
        'data' => DB::table('categories')->where('id', $id)->first()
    ], 201);
});

// 3. Tambah Guru Baru ke tabel teachers
Route::post('/admin/guru', function (Request $request) {
    $validated = $request->validate([
        'nama_guru' => 'required|string|max:150',
        'email' => 'required|email|max:100',
        'spesialisasi' => 'required|string|max:100',
    ]);

    $id = DB::table('teachers')->insertGetId([
        'nama_guru' => $validated['nama_guru'],
        'email' => $validated['email'],
        'spesialisasi' => $validated['spesialisasi'],
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    return response()->json([
        'success' => true,
        'message' => 'Data Guru baru berhasil ditambahkan oleh Admin!',
        'data' => DB::table('teachers')->where('id', $id)->first()
    ], 201);
});


Route::get('/admin/dashboard', function () {
    try {

        $totalPengguna = DB::table('users')->count(); 
        $materiBelajar = DB::table('materis')->count(); 
        
        
        $kontenAktif = DB::getSchemaBuilder()->hasTable('contents') ? DB::table('contents')->count() : 456;
        $pembelajaran = DB::getSchemaBuilder()->hasTable('payments') ? DB::table('payments')->count() : 3200;

        
        $ringkasanAktivitas = [
            [
                "id" => "act_1",
                "title" => "Materi \"Huruf A - BISINDO\"",
                "subtitle" => "siti@email.com",
                "time" => "5m",
                "status" => "materi"
            ],
            [
                "id" => "act_2",
                "title" => "8 Konten sedang Direview",
                "subtitle" => "budi@email.com",
                "time" => "15m",
                "status" => "review"
            ],
            [
                "id" => "act_3",
                "title" => "3 Laporan Perlu tindakan",
                "subtitle" => "budi@email.com",
                "time" => "1hr",
                "status" => "laporan"
            ]
        ];

        
        return response()->json([
            'total_pengguna' => $totalPengguna,
            'konten_aktif' => $kontenAktif,
            'materi_belajar' => $materiBelajar,
            'pembelajaran' => $pembelajaran,
            'ringkasan_aktivitas' => $ringkasanAktivitas
        ], 200);

    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'Gagal memuat dashboard: ' . $e->getMessage()
        ], 500);
    }
});