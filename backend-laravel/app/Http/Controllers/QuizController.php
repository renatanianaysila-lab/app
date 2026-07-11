<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class QuizController extends Controller
{
    /**
     * 1. Mengambil kuis acak berdasarkan materi_id -> KHUSUS MURID (Maksimal 10 Soal)
     */
    public function index(Request $request)
    {
        // Menangkap parameter materi_id dari Flutter
        $materiId = $request->query('materi_id');

        if (!$materiId) {
            return response()->json([
                'success' => false,
                'message' => 'Parameter materi_id wajib disertakan.'
            ], 400);
        }

        // Ambil soal berdasarkan materi_id, diacak (inRandomOrder), dibatasi maksimal 10 soal
        $quizzes = DB::table('quizzes')
            ->where('materi_id', $materiId)
            ->inRandomOrder()
            ->limit(10) 
            ->get();

        // Mapping format agar sesuai dengan variabel state yang diharapkan di Dart/Flutter
        $result = $quizzes->map(function ($item) {
            return [
                'id'             => (int) $item->id, // Dipastikan ke Integer agar tidak memicu TypeError
                'question'       => $item->pertanyaan, // Menyelaraskan kolom database 'pertanyaan'
                'instruction'    => 'Pilihlah salah satu jawaban yang paling tepat!', 
                'gambarPath'     => property_exists($item, 'gambar_path') ? $item->gambar_path : null,
                'options'        => [
                    'A' => $item->opsi_a, // Menyelaraskan kolom database 'opsi_a'
                    'B' => $item->opsi_b,
                    'C' => $item->opsi_c,
                    'D' => $item->opsi_d,
                ],
                'jawabanBenar'   => $item->jawaban_benar,
                'selectedAnswer' => null,
                'isFlagged'      => false,
            ];
        });

        return response()->json($result, 200);
    }

    /**
     * 2. Menyimpan skor hasil kuis siswa ke tabel quiz_scores -> KHUSUS MURID
     */
    public function saveScore(Request $request)
    {
        $request->validate([
            'user_id' => 'required',
            'level'   => 'required|string',
            'skor'    => 'required|integer',
        ]);

        // Menyimpan data ke tabel quiz_scores menggunakan Query Builder
        $inserted = DB::table('quiz_scores')->insert([
            'user_id'    => $request->user_id,
            'level'      => $request->level,
            'skor'       => $request->skor,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        if ($inserted) {
            return response()->json([
                'success' => true,
                'message' => 'Skor kuis berhasil disimpan!'
            ], 201);
        }

        return response()->json([
            'success' => false,
            'message' => 'Gagal menyimpan skor.'
        ], 500);
    }

    /**
     * 3. Menyimpan soal kuis baru secara otomatis per materi -> KHUSUS GURU
     */
    public function store(Request $request)
    {
        // Validasi data yang dikirim dari Flutter
        $request->validate([
            'materi_id'     => 'required|integer', 
            'pertanyaan'    => 'required|string',
            'opsi_a'        => 'required|string',
            'opsi_b'        => 'required|string',
            'opsi_c'        => 'required|string',
            'opsi_d'        => 'required|string',
            'jawaban_benar' => 'required|string|max:1',
            'level'         => 'required|string',
        ]); 

        // Query Insert ke Database
        $id = DB::table('quizzes')->insertGetId([
            'materi_id'     => $request->materi_id,
            'pertanyaan'    => $request->pertanyaan,
            'opsi_a'        => $request->opsi_a,
            'opsi_b'        => $request->opsi_b,
            'opsi_c'        => $request->opsi_c,
            'opsi_d'        => $request->opsi_d,
            'jawaban_benar' => strtoupper($request->jawaban_benar),
            'level'         => $request->level,
            'created_at'    => now(),
            'updated_at'    => now(),
        ]);

        if ($id) {
            return response()->json([
                'success' => true,
                'message' => 'Soal kuis baru berhasil disimpan otomatis!',
                'id'      => $id
            ], 201);
        }

        return response()->json([
            'success' => false, 
            'message' => 'Gagal menyimpan soal.'
        ], 500);
    }

    /**
     * 4. Mengambil SEMUA kuis tanpa acak & tanpa limit -> KHUSUS GURU (Full Bank Soal)
     */
    public function getAllQuizzes(Request $request)
    {
        $materiId = $request->query('materi_id');
        
        $query = DB::table('quizzes');
        if ($materiId) {
            $query->where('materi_id', $materiId);
        }

        // Diambil semua berurutan berdasarkan id terbaru agar guru mudah memantau
        $quizzes = $query->latest('id')->get(); 
        
        return response()->json([
            'success' => true,
            'data'    => $quizzes
        ], 200);
    }

    /**
     * 5. Mengubah/Update Soal Kuis (Khusus Guru)
     */
    public function update(Request $request, $id)
    {
        $request->validate([
            'pertanyaan'    => 'required|string',
            'opsi_a'        => 'required|string',
            'opsi_b'        => 'required|string',
            'opsi_c'        => 'required|string',
            'opsi_d'        => 'required|string',
            'jawaban_benar' => 'required|string|max:1',
        ]);

        DB::table('quizzes')->where('id', $id)->update([
            'pertanyaan'    => $request->pertanyaan,
            'opsi_a'        => $request->opsi_a,
            'opsi_b'        => $request->opsi_b,
            'opsi_c'        => $request->opsi_c,
            'opsi_d'        => $request->opsi_d,
            'jawaban_benar' => strtoupper($request->jawaban_benar),
            'updated_at'    => now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Soal kuis berhasil diperbarui!'
        ], 200);
    }

    /**
     * 6. Menghapus Soal Kuis dari Database (Khusus Guru)
     */
    public function destroy($id)
    {
        $deleted = DB::table('quizzes')->where('id', $id)->delete();

        if ($deleted) {
            return response()->json([
                'success' => true,
                'message' => 'Soal kuis berhasil dihapus!'
            ], 200);
        }

        return response()->json([
            'success' => false, 
            'message' => 'Soal tidak ditemukan.'
        ], 404);
    }
}