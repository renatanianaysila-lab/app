<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Materi;
use App\Models\Guru;

class MateriGuruController extends Controller
{
    public function index(Request $request)
    {
        // 1. Ambil ID User yang sedang login dari Token Secure Sanctum
        $user = $request->user(); 

        // 2. Cari data guru yang memiliki user_id tersebut
        $guru = Guru::where('user_id', $user->id)->first();

        if (!$guru) {
          return response()->json(['status' => 'error', 'message' => 'Data guru tidak ditemukan.'], 404);
        }

        // 3. Ambil kategori (Dasar/Menengah/Lanjutan) yang dikirim dari tab Flutter
        $kategori = $request->query('kategori', 'Dasar');

        // 4. Query otomatis: Hanya ambil materi milik GURU INI dan KATEGORI INI
        $materi = Materi::where('guru_id', $guru->guru_id)
                        ->where('kategori', $kategori)
                        ->get();

        return response()->json([
            'status' => 'success',
            'data' => $materi
        ], 200);
    }
}