<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller; 

class ForumController extends Controller
{
    // 1. Fungsi buat ngambil semua data postingan
    public function index()
    {
        $forums = DB::table('forums')->orderBy('created_at', 'desc')->get();

        return response()->json([
            'success' => true,
            'message' => 'Daftar diskusi forum berhasil diambil',
            'data' => $forums
        ], 200);
    }

    // 2. Fungsi baru buat nyimpen postingan otomatis dari Flutter 🎯
    public function store(Request $request)
    {
        // 1. Validasi kiriman data dari Flutter
        $request->validate([
            'username' => 'required|string',
            'role' => 'required|string', 
            'content' => 'required|string',
        ]);

        // 2. Masukkan ke kolom database asli kamu + kolom role baru! 🎯
        $id = DB::table('forums')->insertGetId([
            'pembuat' => $request->username,
            'judul' => 'Diskusi',
            'konten' => $request->content, 
            'role' => $request->role,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $newPost = DB::table('forums')->where('id', $id)->first();

        return response()->json([
            'success' => true,
            'message' => 'Berhasil membuat postingan baru',
            'data' => $newPost
        ], 201);
    }
}