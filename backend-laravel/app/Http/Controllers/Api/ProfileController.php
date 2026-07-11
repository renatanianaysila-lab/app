<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    public function show(Request $request)
    {
        // Contoh logika ambil data user yang sedang login
        return response()->json([
            'status' => 'success',
            'data' => $request->user(),
        ]);
    }
}