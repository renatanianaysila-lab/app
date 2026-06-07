<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // DAFTAR SEEDER UTAMA ISYARATKITA:
        $this->call([
            MateriSeeder::class,      // Seeder materi video kelola guru
            ForumSeeder::class,       // Seeder obrolan forum
            QuizSeeder::class,        // Seeder bank soal kuis baru
            PackageSeeder::class,     // Seeder paket aplikasi
            TransactionSeeder::class, // Seeder data transaksi
            QuizScoreSeeder::class,   // Seeder nilai kuis murid
        ]);
    }
}