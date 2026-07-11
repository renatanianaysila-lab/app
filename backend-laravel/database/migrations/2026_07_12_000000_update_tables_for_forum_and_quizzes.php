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
        // 1. Update forums table
        Schema::table('forums', function (Blueprint $table) {
            if (!Schema::hasColumn('forums', 'pembuat_id')) {
                $table->string('pembuat_id')->nullable()->after('pembuat');
            }
            if (!Schema::hasColumn('forums', 'media_url')) {
                $table->string('media_url')->nullable()->after('pembuat_id');
            }
            if (!Schema::hasColumn('forums', 'media_type')) {
                $table->string('media_type')->default('none')->after('media_url');
            }
            if (!Schema::hasColumn('forums', 'role')) {
                $table->string('role')->nullable()->after('media_type');
            }
            if (!Schema::hasColumn('forums', 'likes_count')) {
                $table->integer('likes_count')->default(0)->after('role');
            }
        });

        // 2. Create forum_replies table
        if (!Schema::hasTable('forum_replies')) {
            Schema::create('forum_replies', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('forum_id');
                $table->string('pembuat_id');
                $table->text('konten');
                $table->string('role');
                $table->timestamps();
            });
        }

        // 3. Update quizzes table
        Schema::table('quizzes', function (Blueprint $table) {
            if (!Schema::hasColumn('quizzes', 'materi_id')) {
                $table->unsignedBigInteger('materi_id')->nullable()->after('level');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('quizzes', function (Blueprint $table) {
            if (Schema::hasColumn('quizzes', 'materi_id')) {
                $table->dropColumn('materi_id');
            }
        });

        Schema::dropIfExists('forum_replies');

        Schema::table('forums', function (Blueprint $table) {
            $cols = ['pembuat_id', 'media_url', 'media_type', 'role', 'likes_count'];
            foreach ($cols as $col) {
                if (Schema::hasColumn('forums', $col)) {
                    $table->dropColumn($col);
                }
            }
        });
    }
};
