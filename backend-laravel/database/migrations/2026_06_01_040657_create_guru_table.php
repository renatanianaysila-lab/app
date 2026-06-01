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
        Schema::create('guru', function (Blueprint $table) {
        $table->char('guru_id', 5)->primary(); 
        $table->string('nama_guru', 100);
        $table->string('email_guru', 100)->unique();
        $table->string('password_guru', 255);
        $table->string('foto_profil_guru', 255)->nullable();
        $table->string('sertifikasi', 255)->nullable();
        $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('guru');
    }
};
