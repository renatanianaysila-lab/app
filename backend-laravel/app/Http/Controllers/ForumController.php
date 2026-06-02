<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller; 

class ForumController extends Controller
{
    public function index()
    {
        // Mengambil semua data obrolan forum dari database MySQL
        $forums = DB::table('forums')->get();

        return response()->json([
            'success' => true,
            'message' => 'Daftar diskusi forum berhasil diambil',
            'data' => $forums
        ], 200);
    }
}