<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class QuizController extends Controller
{
    public function index($kategori)
    {
        // Mengambil data dari tabel quizzes di phpMyAdmin berdasarkan kategorinya (angka/abjad)
        $quizzes = DB::table('quizzes')->where('kategori', $kategori)->get();

        // Format datanya dibungkus agar pas dengan struktur yang diminta Flutter
        $result = $quizzes->map(function ($item) {
            return [
                'id' => $item->id,
                'question' => $item->question,
                'instruction' => $item->instruction,
                'gambarPath' => $item->gambar_path,
                'options' => [
                    'A' => $item->option_a,
                    'B' => $item->option_b,
                    'C' => $item->option_c,
                    'D' => $item->option_d,
                ],
                'jawabanBenar' => $item->jawaban_benar,
                'selectedAnswer' => null,
                'isFlagged' => false,
            ];
        });

        return response()->json($result, 200);
    }
}