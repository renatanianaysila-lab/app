<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MateriSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('materis')->insert([
            [
                'judul' => 'Abjad Isyarat (A - E)',
                'kategori' => 'Abjad',
                'deskripsi' => 'Belajar gerakan dasar bahasa isyarat untuk huruf A sampai E.',
                'video_url' => 'https://www.w3schools.com/html/mov_bbb.mp4',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'judul' => 'Angka Dasar (1 - 5)',
                'kategori' => 'Angka',
                'deskripsi' => 'Pengenalan simbol angka 1 sampai 5 menggunakan satu tangan.',
                'video_url' => 'https://www.w3schools.com/html/movie.mp4',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'judul' => 'Kata Sapaan Sehari-hari',
                'kategori' => 'Percakapan',
                'deskripsi' => 'Cara mengucapkan Halo, Terima Kasih, dan Selamat Pagi.',
                'video_url' => 'https://www.w3schools.com/html/mov_bbb.mp4',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}