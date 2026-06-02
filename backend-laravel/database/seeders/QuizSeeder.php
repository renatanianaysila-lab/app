<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class QuizSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('quizzes')->insert([
            [
                'pertanyaan' => 'Manakah simbol gerakan tangan yang melambangkan huruf "A" dalam BISINDO?',
                'opsi_a' => 'Mengepalkan tangan dengan jempol berdiri di samping',
                'opsi_b' => 'Membentuk lingkaran dengan telunjuk dan jempol',
                'opsi_c' => 'Membuka kelima jari tegak ke atas',
                'opsi_d' => 'Menyilangkan jari telunjuk dan jari tengah',
                'jawaban_benar' => 'A',
                'level' => 'Beginner',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'pertanyaan' => 'Jika ingin mengisyaratkan angka "5" dasar, berapa jumlah jari yang harus dibuka?',
                'opsi_a' => '2 Jari',
                'opsi_b' => '3 Jari',
                'opsi_c' => '4 Jari',
                'opsi_d' => '5 Jari (Telapak tangan terbuka)',
                'jawaban_benar' => 'D',
                'level' => 'Beginner',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}