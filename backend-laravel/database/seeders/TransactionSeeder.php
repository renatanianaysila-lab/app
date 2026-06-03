<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class TransactionSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('transactions')->insert([
            [
                'user_id' => 1,
                'package_id' => 1, // Paket Bulanan
                'status' => 'success',
                'total_harga' => 30000,
                'metode_pembayaran' => 'QRIS',
                'created_at' => now()->subDays(2),
                'updated_at' => now()->subDays(2),
            ]
        ]);
    }
}