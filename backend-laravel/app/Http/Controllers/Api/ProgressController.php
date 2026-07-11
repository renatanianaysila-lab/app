<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ProgressController extends Controller
{
    public function getProgresSiswa(Request $request)
    {
        // 1. Tangkap langsung filter dari Flutter ('Mudah', 'Sedang', 'Susah')
        $kategoriInput = $request->query('kelas', 'Mudah');

        // 2. Ambil semua data murid asli dari tabel murid
        $murids = DB::table('murid')->get();
        
        // 3. Hitung total materi yang ada di kategori tersebut
        $totalMateri = DB::table('materis')->where('kategori', $kategoriInput)->count();

        $dataProgres = [];

        foreach ($murids as $murid) {
            // Jembatan relasi: karena user_progress pakai 'user_id' (bigint/users.id), 
            // kita cari dulu ID user yang emailnya cocok dengan email_murid ini.
            $userAccount = DB::table('users')->where('email', $murid->email_murid)->first();

            // Jika akun user-nya belum ada di tabel users, set progres 0% biar ga crash
            if (!$userAccount) {
                $dataProgres[] = [
                    'nama' => $murid->nama_murid,
                    'overall_progress' => '0%',
                    'details' => [
                        ['title' => 'Tonton Video Pembelajaran', 'status' => '0 dari ' . $totalMateri . ' Materi Selesai', 'percentage' => '0%', 'score' => null],
                        ['title' => 'Evaluasi Kuis Kelas', 'status' => 'Belum Mengerjakan', 'percentage' => '0%', 'score' => 'Belum Kuis']
                    ]
                ];
                continue;
            }

            // 4. Hitung materi selesai yang BENAR-BENAR milik ID user ini
            $materiSelesaiCount = DB::table('user_progress')
                ->join('materis', 'user_progress.materi_id', '=', 'materis.id')
                ->where('user_progress.user_id', $userAccount->id)
                ->where('materis.kategori', $kategoriInput)
                ->where('user_progress.is_completed', 1)
                ->count();

            // 5. Hitung persentase nonton video secara akurat
            $persentaseVideo = $totalMateri > 0 ? round(($materiSelesaiCount / $totalMateri) * 100) : 0;

            // 6. Ambil skor kuis asli dari tabel quiz_scores (jika ada)
            $quizScore = DB::table('quiz_scores')
                ->where('user_id', $userAccount->id)
                ->orderBy('created_at', 'desc')
                ->first();

            $statusKuis = $quizScore ? 'Selesai Dikerjakan' : 'Belum Mengerjakan';
            $persentaseKuis = $quizScore ? $quizScore->score . '%' : '0%';
            $textSkor = $quizScore ? 'Skor: ' . $quizScore->score : 'Belum Kuis';

            // 7. Masukkan ke array dengan format yang pas dengan index [0] dan [1] di Flutter-mu
            $dataProgres[] = [
                'nama' => $murid->nama_murid,
                'overall_progress' => $persentaseVideo . '%',
                'details' => [
                    [
                        'title' => 'Tonton Video Pembelajaran',
                        'status' => $materiSelesaiCount . ' dari ' . $totalMateri . ' Materi Selesai',
                        'percentage' => $persentaseVideo . '%',
                        'score' => null,
                    ],
                    [
                        'title' => 'Evaluasi Kuis Kelas',
                        'status' => $statusKuis,
                        'percentage' => $persentaseKuis,
                        'score' => $textSkor,
                    ]
                ]
            ];
        }

        return response()->json([
            'success' => true,
            'data' => $dataProgres
        ], 200);
    }
}