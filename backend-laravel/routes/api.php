<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\MateriController;
use App\Http\Controllers\QuizController;
use App\Http\Controllers\ForumController;
use App\Http\Controllers\Api\ProgressController;
use App\Http\Controllers\CommentController;
use App\Http\Controllers\Api\ProfileController;

Route::get('/profile', [ProfileController::class, 'show']);
Route::get('/user/{id}', [UserController::class, 'getUser']);
Route::post('/user/{id}/foto', [UserController::class, 'uploadFoto']);

// ==========================================
// ─── 1. RUTE AUTENTIKASI USER ───
// ==========================================
Route::post('/register/murid', [UserController::class, 'registerMurid']);
Route::post('/register/guru', [UserController::class, 'registerGuru']);
Route::post('/register/admin', [UserController::class, 'registerAdmin']);
Route::post('/login', [UserController::class, 'login']);


// ==========================================
// ─── 2. RUTE BERANDA & PROFIL GURU ───
// ==========================================
Route::post('/guru/profile/{id}/upload-avatar', [ProfileController::class, 'uploadAvatar']);

Route::get('/guru/profil', function (Request $request) {
    $guruId = $request->query('guru_id', 'G0001');
    $guru = DB::table('guru')->where('guru_id', $guruId)->first();
    $daftarModul = DB::table('materis')
        ->where('guru_id', $guruId)
        ->whereNotNull('nama_modul')
        ->distinct()
        ->get(['nama_modul', 'kategori']);

    $kelasData = [];
    $idCounter = 1;

    foreach ($daftarModul as $modul) {
        $kelasData[] = [
            'id' => $idCounter++,
            'nama_kelas' => $modul->nama_modul,
            'kategori' => $modul->kategori,
            'jumlah_materi' => DB::table('materis')
                ->where('nama_modul', $modul->nama_modul)
                ->where('guru_id', $guruId)
                ->count()
        ];
    }

    return response()->json([
        'success' => true,
        'data' => [
            'nama_guru' => $guru ? $guru->nama_guru : 'Pak Budi, S.Pd.',
            'jumlah_siswa' => DB::table('murid')->count(),
            'jumlah_kelas' => count($kelasData),
            'rating' => 4.8,
            'kelas' => $kelasData
        ]
    ], 200);
});

// ==========================================
// ─── 3. RUTE MATERI (SISWA & GURU) ───
// ==========================================
Route::get('/materi/levels', [MateriController::class, 'levels']);
Route::get('/materi/{video_id}', [MateriController::class, 'show']);

Route::get('/materis', [MateriController::class, 'index']);
Route::post('/materis', [MateriController::class, 'store']);

// Filter materi per kategori + guru tertentu (buat halaman GURU, bukan murid).
// Sebelumnya path-nya numpuk sama '/materis' di atas jadi gak pernah kepanggil.
// Sekarang path-nya dipisah + mapping kategori dibenerin (Susah -> Lanjutan).
Route::get('/materis/filter', function (Request $request) {
    $kategoriInput = $request->query('kategori', 'Dasar');
    $guruIdInput = $request->query('guru_id', 'G0001');

    $kategoriDb = 'Dasar';
    if ($kategoriInput == 'Intermediate' || $kategoriInput == 'Menengah') {
        $kategoriDb = 'Menengah';
    } elseif ($kategoriInput == 'Lanjutan' || $kategoriInput == 'Susah') {
        $kategoriDb = 'Lanjutan';
    }

    $materis = DB::table('materis')
        ->where('kategori', $kategoriDb)
        ->where('guru_id', $guruIdInput)
        ->get();

    return response()->json([
        'success' => true,
        'data' => $materis
    ], 200);
});

// ==========================================
// ─── 4. RUTE PROGRESS BELAJAR SISWA ───
// ==========================================
Route::get('/guru/progres', [ProgressController::class, 'getProgresSiswa']);

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

// Tandai 1 materi selesai ditonton -> BELUM ADA sebelumnya, dibutuhin buat unlock kuis level.
// Ditulis inline (bukan controller baru) biar gak nambah file.
Route::post('/user/progress', function (Request $request) {
    $request->validate([
        'user_id'   => 'required',
        'materi_id' => 'required|integer',
    ]);

    $existing = DB::table('user_progress')
        ->where('user_id', $request->user_id)
        ->where('materi_id', $request->materi_id)
        ->first();

    if ($existing) {
        DB::table('user_progress')
            ->where('id', $existing->id)
            ->update(['is_completed' => 1, 'updated_at' => now()]);
    } else {
        DB::table('user_progress')->insert([
            'user_id'      => $request->user_id,
            'materi_id'    => $request->materi_id,
            'is_completed' => 1,
            'created_at'   => now(),
            'updated_at'   => now(),
        ]);
    }

    return response()->json(['success' => true, 'message' => 'Progress materi diperbarui.'], 200);
});

// ==========================================
// ─── 5. RUTE FORUM DISKUSI ───
// ==========================================
Route::get('/forums', [ForumController::class, 'index']);
Route::post('/forums', [ForumController::class, 'store']);
Route::post('/forums/{id}/reply', [ForumController::class, 'storeReply']);
Route::post('/forums/{id}/like', [ForumController::class, 'toggleLike']);

// ==========================================
// ─── 6. RUTE KUIS & RIWAYAT NILAI ───
// ==========================================
Route::get('/quizzes/level/{level}', [QuizController::class, 'byLevel']);
Route::get('/quizzes', [QuizController::class, 'index']);
Route::post('/quizzes', [QuizController::class, 'store']);
Route::put('/quizzes/{id}', [QuizController::class, 'update']);
Route::delete('/quizzes/{id}', [QuizController::class, 'destroy']);

// Nama endpoint skor DISAMAIN ke '/quiz-scores' (yang udah eksis di file kamu),
// bukan '/skor-kuis' kayak yang aku pakai di kode Flutter sebelumnya.
Route::get('/quiz-scores', [QuizController::class, 'getScore']);
Route::post('/quiz-scores', [QuizController::class, 'saveScore']);

Route::get('/quiz/history', function () {
    return response()->json([
        'success' => true,
        'message' => 'Semua riwayat nilai kuis berhasil diambil',
        'data' => DB::table('quiz_scores')->orderBy('created_at', 'desc')->get()
    ], 200);
});

Route::get('/guru/quizzes', [QuizController::class, 'getAllQuizzes']);

// ==========================================
// ─── 7. RUTE PEMBAYARAN & SUBSCRIPTION ───
// ==========================================
Route::post('/payment', [PaymentController::class, 'createPayment']);
Route::post('/payment/{id}/confirm', [PaymentController::class, 'confirmPayment']);
Route::get('/transactions', [PaymentController::class, 'getTransactions']);

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

// ==========================================
// ─── 8. RUTE PANEL INPUT ADMIN & DASHBOARD ───
// ==========================================
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

// ⚠️ Tabel 'categories' GAK ADA di database kamu -> bakal 500 kalau dipanggil.
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

// ⚠️ Tabel 'teachers' juga GAK ADA (yang ada 'guru') -> bakal 500 kalau dipanggil.
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
        $kontenAktif = $materiBelajar;
        $pembelajaran = DB::table('quiz_scores')->count();

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

Route::get('/admin/guru', function () {
    try {
        $guru = DB::table('guru')->get()->map(function ($item) {
            return [
                'id'     => $item->guru_id,
                'nama'   => $item->nama_guru,
                'email'  => $item->email_guru,
                'status' => $item->status ?? 'Aktif',
            ];
        });
        return response()->json(['success' => true, 'data' => $guru], 200);
    } catch (\Exception $e) {
        return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
    }
});

Route::get('/admin/murid', function () {
    try {
        $murid = DB::table('murid')->get()->map(function ($item) {
            return [
                'id'     => $item->murid_id,
                'nama'   => $item->nama_murid,
                'email'  => $item->email_murid,
                'status' => 'Aktif',
            ];
        });
        return response()->json(['success' => true, 'data' => $murid], 200);
    } catch (\Exception $e) {
        return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
    }
});

Route::get('/admin/konten', function () {
    try {
        $materi = DB::table('materis')->get()->map(function ($item) {
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
                'penulis'  => 'Admin',
                'kategori' => $item->kategori ?? 'Dasar',
                'level'    => $item->kategori ?? 'Dasar',
                'status'   => 'disetujui',
                'warna'    => $kategoriColor,
            ];
        });
        return response()->json(['success' => true, 'data' => $materi], 200);
    } catch (\Exception $e) {
        return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
    }
});

Route::get('/admin/aktivitas', function () {
    try {
        $aktivitas = [];

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

        usort($aktivitas, fn($a, $b) => strcmp($b['sort_time'], $a['sort_time']));

        $result = array_map(function ($item) {
            unset($item['sort_time']);
            return $item;
        }, $aktivitas);

        return response()->json(['success' => true, 'data' => $result], 200);
    } catch (\Exception $e) {
        return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
    }
});

Route::get('/admin/laporan', function () {
    try {
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
                'tipe'    => 'Masuk',
            ];
        })->toArray();

        $totalMasuk = DB::table('transactions')->where('status', 'success')->sum('total_harga');
        $totalMasukBulanIni = DB::table('transactions')->where('status', 'success')->whereMonth('created_at', now()->month)->sum('total_harga');
        $jumlahTransaksi = DB::table('transactions')->count();
        $menunggu = DB::table('transactions')->where('status', 'pending')->sum('total_harga');

        $hariIndo = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
        $mingguan = [];
        for ($i = 6; $i >= 0; $i--) {
            $tanggal = now()->subDays($i);
            $nilai = DB::table('transactions')->where('status', 'success')->whereDate('created_at', $tanggal->toDateString())->sum('total_harga');
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

// ==========================================
// ─── 9. RUTE KOMENTAR & DISKUSI VIDEO ───
// ==========================================
Route::get('/comments', [CommentController::class, 'getComments']);
Route::post('/comments', [CommentController::class, 'storeComment']);

Route::get('/teacher/dashboard-stats', [CommentController::class, 'getDashboardStats']);

Route::post('/admin/guru/{id}/approve', function ($id) {
    DB::table('guru')->where('guru_id', $id)->update(['status' => 'aktif']);

    return response()->json([
        'success' => true,
        'message' => 'Guru berhasil di-approve!'
    ], 200);
});