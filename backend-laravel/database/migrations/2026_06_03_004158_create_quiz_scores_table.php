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
        Schema::create('quiz_scores', function (Blueprint $table) {
        $table->id();
        $table->integer('user_id'); // ID Murid yang mengerjakan kuis
        $table->string('level');    // Beginner / Intermediate / Advanced
        $table->integer('skor');     // Nilai kuis (misal: 100)
        $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('quiz_scores');
    }
};
