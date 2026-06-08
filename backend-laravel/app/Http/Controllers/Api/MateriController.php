<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class MateriController extends Controller
{
    public function index(Request $request)
    {
        $kategori = $request->query('kategori');
        
        // Memastikan query mengambil kolom nama_modul
        $query = DB::table('materis');

        if ($kategori) {
            $query->where('kategori', $kategori);
        }

        $materis = $query->get();

        return response()->json([
            'success' => true,
            'data' => $materis
        ], 200);
    }
}