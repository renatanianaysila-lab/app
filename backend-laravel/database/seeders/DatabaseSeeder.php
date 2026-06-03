<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

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
            MateriSeeder::class, // Seeder materi video yang kemarin
            ForumSeeder::class,  // Seeder obrolan forum yang kemarin
            QuizSeeder::class, // Seeder bank soal kuis baru kita
            PackageSeeder::class,  
            TransactionSeeder::class,
            QuizScoreSeeder::class,
        ]);
    }
}