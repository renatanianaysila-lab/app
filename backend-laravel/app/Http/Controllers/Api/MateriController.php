<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class MateriController extends Controller
{
    public function index(Request $request)
    {
        // Ambil parameter kategori dari Flutter jika ada (misal: /api/materi?kategori=Dasar)
        $kategori = $request->query('kategori');

        $query = DB::table('materis');

        if ($kategori) {
            $query->where('kategori', $kategori);
        }

        $materis = $query->get();

        return response()->json([
            'success' => true,
            'message' => 'Daftar materi berhasil diambil',
            'data' => $materis
        ], 200);
    }
}