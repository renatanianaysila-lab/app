<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class QuizController extends Controller
{
    /**
     * 1. Mengambil kuis acak berdasarkan materi_id / video tertentu
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
     * 2. Menyimpan skor hasil kuis siswa ke tabel quiz_scores
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
}