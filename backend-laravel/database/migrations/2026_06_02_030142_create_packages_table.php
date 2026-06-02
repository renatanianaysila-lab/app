<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('packages', function (Blueprint $table) {
        $table->id();
        $table->string('nama_paket'); // Misal: Paket Bulanan, Paket Tahunan
        $table->integer('harga');      // Misal: 30000, 149000
        $table->string('deskripsi');  // Keunggulan paket
        $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('packages');
    }
};
