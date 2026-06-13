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
        $kontenAktif = $materiBelajar; // pakai jumlah materi sebagai konten aktif
        $pembelajaran = DB::table('quiz_scores')->count(); // pakai jumlah skor kuis

        $ringkasanAktivitas = DB::table('materis')
            ->latest()
            ->take(6)
            ->get()
            ->map(function ($item) {
                return [
                    'id' => $item->id,
                    'title' => $item->judul,
                    'subtitle' => 'bisindo@email.com',
                    'time' => \Carbon\Carbon::parse($item->created_at)->diffForHumans(),
                    'status' => 'materi',
                ];
            })->toArray();

        return response()->json([
            'total_pengguna' => $totalPengguna,
            'konten_aktif' => $kontenAktif,
            'materi_belajar' => $materiBelajar,
            'pembelajaran' => $pembelajaran,
            'ringkasan_aktivitas' => $ringkasanAktivitas,
        ], 200);

    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'Gagal: ' . $e->getMessage()
        ], 500);
    }
});

// ─── TAMBAHKAN INI DI BAWAH ROUTE /admin/dashboard ───────────────────────────

// Daftar Guru (dari tabel 'guru')
Route::get('/admin/guru', function () {
    try {
        $guru = DB::table('guru')->get()->map(function ($item) {
            return [
                'id'     => $item->guru_id,
                'nama'   => $item->nama_guru,
                'email'  => $item->email_guru,
                'status' => 'Aktif', // tabel guru belum punya kolom status, default Aktif
            ];
        });

        return response()->json(['success' => true, 'data' => $guru], 200);
    } catch (\Exception $e) {
        return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
    }
});

// Daftar Murid/Siswa (dari tabel 'murid')
Route::get('/admin/murid', function () {
    try {
        $murid = DB::table('murid')->get()->map(function ($item) {
            return [
                'id'     => $item->murid_id,
                'nama'   => $item->nama_murid,
                'email'  => $item->email_murid,
                'status' => 'Aktif', // tabel murid belum punya kolom status, default Aktif
            ];
        });

        return response()->json(['success' => true, 'data' => $murid], 200);
    } catch (\Exception $e) {
        return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
    }
});

// Daftar Materi/Konten untuk admin (dari tabel 'materis')
// Karena tabel materis belum punya kolom 'status_konten', kita pakai kategori
// sebagai sumber data, dan status default 'disetujui' (karena sudah ada di DB)
Route::get('/admin/konten', function () {
    try {
        $materi = DB::table('materis')->get()->map(function ($item) {
            // Tentukan warna icon berdasarkan kategori
            $kategoriColor = match(strtolower($item->kategori ?? '')) {
                'abjad'       => '#6C63FF',
                'angka'       => '#4CAF50',
                'ekspresi'    => '#9C27B0',
                'percakapan'  => '#FF6B35',
                default       => '#F5A623',
            };

            return [
                'id'       => $item->id,
                'judul'    => $item->judul,
                'penulis'  => 'Admin', // belum ada kolom penulis di materis
                'kategori' => $item->kategori ?? 'Dasar',
                'level'    => $item->kategori ?? 'Dasar',
                'status'   => 'disetujui', // semua materi di DB dianggap sudah disetujui
                'warna'    => $kategoriColor,
            ];
        });

        return response()->json(['success' => true, 'data' => $materi], 200);
    } catch (\Exception $e) {
        return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
    }
});

// ─── AKTIVITAS ADMIN ─────────────────────────────────────────────────────────
// Fetch aktivitas dari tabel materis, users, quiz_scores
Route::get('/admin/aktivitas', function () {
    try {
        $aktivitas = [];

        // Unggah: materi terbaru
        $materis = DB::table('materis')->latest()->take(5)->get();
        foreach ($materis as $m) {
            $aktivitas[] = [
                'tipe'       => 'Unggah',
                'pesan'      => 'Materi "' . $m->judul . '" berhasil diunggah',
                'waktu'      => \Carbon\Carbon::parse($m->created_at)->diffForHumans(),
                'badgeLabel' => 'Unggah',
                'sort_time'  => $m->created_at,
            ];
        }

        // Lainnya: pengguna baru (dari tabel users)
        $users = DB::table('users')->latest()->take(3)->get();
        foreach ($users as $u) {
            $aktivitas[] = [
                'tipe'       => 'Lainnya',
                'pesan'      => ($u->name ?? 'Pengguna baru') . ' mendaftar sebagai anggota baru',
                'waktu'      => \Carbon\Carbon::parse($u->created_at)->diffForHumans(),
                'badgeLabel' => 'Daftar',
                'sort_time'  => $u->created_at,
            ];
        }

        // Lainnya: kuis diselesaikan
        $scores = DB::table('quiz_scores')->latest()->take(3)->get();
        foreach ($scores as $s) {
            $aktivitas[] = [
                'tipe'       => 'Lainnya',
                'pesan'      => 'Kuis level ' . ($s->level ?? '-') . ' diselesaikan dengan skor ' . $s->skor,
                'waktu'      => \Carbon\Carbon::parse($s->created_at)->diffForHumans(),
                'badgeLabel' => 'Kuis',
                'sort_time'  => $s->created_at,
            ];
        }

        // Urutkan berdasarkan waktu terbaru
        usort($aktivitas, fn($a, $b) => strcmp($b['sort_time'], $a['sort_time']));

        // Hapus sort_time sebelum kirim
        $result = array_map(function ($item) {
            unset($item['sort_time']);
            return $item;
        }, $aktivitas);

        return response()->json(['success' => true, 'data' => $result], 200);

    } catch (\Exception $e) {
        return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
    }
});

// ─── LAPORAN KEUANGAN ADMIN (UPDATED) ────────────────────────────────────────
Route::get('/admin/laporan', function () {
    try {
        // Ambil transaksi + join ke users dan packages
        $transaksiRaw = DB::table('transactions')
            ->leftJoin('users', 'transactions.user_id', '=', 'users.id')
            ->leftJoin('packages', 'transactions.package_id', '=', 'packages.id')
            ->select(
                'transactions.id',
                'transactions.total_harga',
                'transactions.metode_pembayaran',
                'transactions.status',
                'transactions.created_at',
                'users.name as user_name',
                'packages.nama_paket'
            )
            ->latest('transactions.created_at')
            ->get();

        $transaksi = $transaksiRaw->map(function ($t) {
            $nominal = '+Rp ' . number_format($t->total_harga ?? 0, 0, ',', '.');

            return [
                'judul'   => $t->nama_paket ?? 'Paket Tidak Diketahui',
                'sub'     => 'oleh ' . ($t->user_name ?? 'Pengguna') . ' • ' .
                             \Carbon\Carbon::parse($t->created_at)->translatedFormat('d F Y'),
                'nominal' => $nominal,
                'status'  => $t->status === 'success' ? 'Berhasil' : 'Diproses',
                'tipe'    => 'Masuk', // semua transaksi di tabel ini adalah pembayaran masuk
            ];
        })->toArray();

        // Summary
        $totalMasuk = DB::table('transactions')
            ->where('status', 'success')
            ->sum('total_harga');

        $totalMasukBulanIni = DB::table('transactions')
            ->where('status', 'success')
            ->whereMonth('created_at', now()->month)
            ->sum('total_harga');

        $jumlahTransaksi = DB::table('transactions')->count();

        $menunggu = DB::table('transactions')
            ->where('status', 'pending')
            ->sum('total_harga');

        // Data mingguan (7 hari terakhir)
        $hariIndo = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
        $mingguan = [];
        for ($i = 6; $i >= 0; $i--) {
            $tanggal = now()->subDays($i);
            $nilai = DB::table('transactions')
                ->where('status', 'success')
                ->whereDate('created_at', $tanggal->toDateString())
                ->sum('total_harga');

            $mingguan[] = [
                'hari'      => $hariIndo[$tanggal->dayOfWeek],
                'nilai'     => (float) $nilai,
                'highlight' => $i === 0,
            ];
        }

        return response()->json([
            'success'   => true,
            'transaksi' => $transaksi,
            'summary'   => [
                'saldo'            => 'Rp ' . number_format($totalMasuk, 0, ',', '.'),
                'bulan_ini'        => 'Rp ' . number_format($totalMasukBulanIni, 0, ',', '.'),
                'jumlah_transaksi' => $jumlahTransaksi,
                'menunggu'         => 'Rp ' . number_format($menunggu, 0, ',', '.'),
                'mingguan'         => $mingguan,
            ],
        ], 200);

    } catch (\Exception $e) {
        return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
    }
});
