<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class PackageSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('packages')->insert([
            [
                'nama_paket' => 'Paket Isyarat Bulanan',
                'harga' => 30000,
                'deskripsi' => 'Akses penuh seluruh materi video abjad & forum diskusi selama 1 bulan.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nama_paket' => 'Paket Isyarat Tahunan',
                'harga' => 249000,
                'deskripsi' => 'Akses penuh seluruh materi, kuis eksklusif, sertifikat digital selama 1 tahun.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}