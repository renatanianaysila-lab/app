<?php

namespace App\Http\Controllers\Api;

use Illuminate\Routing\Controller;
use Illuminate\Http\Request;

class MateriController extends Controller
{
    public function index()
    {
        $materi = [
            [
                'id' => 1,
                'judul' => 'Abjad Isyarat (A - E)',
                'kategori' => 'Abjad',
                'deskripsi' => 'Belajar gerakan dasar bahasa isyarat untuk huruf A sampai E.',
                'video_url' => 'https://www.w3schools.com/html/mov_bbb.mp4' // Contoh video dummy
            ],
            [
                'id' => 2,
                'judul' => 'Angka Dasar (1 - 5)',
                'kategori' => 'Angka',
                'deskripsi' => 'Pengenalan simbol angka 1 sampai 5 menggunakan satu tangan.',
                'video_url' => 'https://www.w3schools.com/html/movie.mp4'
            ],
            [
                'id' => 3,
                'judul' => 'Kata Sapaan (Halo, Terima Kasih)',
                'kategori' => 'Percakapan',
                'deskripsi' => 'Cara menyapa dan berterima kasih kepada teman tuli.',
                'video_url' => 'https://www.w3schools.com/html/mov_bbb.mp4'
            ]
        ];

        return response()->json([
            'success' => true,
            'message' => 'Daftar materi berhasil diambil',
            'data' => $materi
        ], 200);
    }
}