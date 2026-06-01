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
        Schema::create('murid', function (Blueprint $table) {
            $table->char('murid_id', 5)->primary(); 
            $table->string('nama_murid', 100);
            $table->string('email_murid', 100)->unique();
            $table->string('password_murid', 255); 
            $table->string('foto_profil_murid', 255)->nullable();
            $table->date('tanggal_lahir');
            $table->timestamp('tanggal_daftar')->useCurrent();
            $table->timestamps(); 
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('murid');
    }
};