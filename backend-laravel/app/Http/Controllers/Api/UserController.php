<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Murid;
use App\Models\Guru;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    // 1. FUNGSI REGISTER MURID
    public function registerMurid(Request $request)
    {
        $request->validate([
            'nama_murid' => 'required|string|max:100',
            'email_murid' => 'required|email|unique:murid,email_murid',
            'password_murid' => 'required|string|min:8',
            'tanggal_lahir' => 'required|date'
        ]);

        // Membuat ID otomatis (M0001, M0002, dst)
        $latest = Murid::orderBy('murid_id', 'desc')->first();
        $nextId = $latest ? 'M' . sprintf('%04d', substr($latest->murid_id, 1) + 1) : 'M0001';

        $murid = Murid::create([
            'murid_id' => $nextId,
            'nama_murid' => $request->nama_murid,
            'email_murid' => $request->email_murid,
            'password_murid' => Hash::make($request->password_murid), 
            'tanggal_lahir' => $request->tanggal_lahir,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Akun murid berhasil dibuat!',
            'data' => $murid
        ], 201);
    }

    // 2. FUNGSI LOGIN (MURID / GURU)
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
            'role' => 'required|in:murid,guru'
        ]);

        if ($request->role == 'murid') {
            $user = Murid::where('email_murid', $request->email)->first();
            if (!$user || !Hash::check($request->password, $user->password_murid)) {
                return response()->json(['status' => 'error', 'message' => 'Email atau password Murid salah'], 401);
            }
            $token = $user->createToken('muridToken')->plainTextToken;
        } else {
            $user = Guru::where('email_guru', $request->email)->first();
            if (!$user || !Hash::check($request->password, $user->password_guru)) {
                return response()->json(['status' => 'error', 'message' => 'Email atau password Guru salah'], 401);
            }
            $token = $user->createToken('guruToken')->plainTextToken;
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Login berhasil!',
            'token' => $token,
            'role' => $request->role,
            'user' => $user
        ], 200);
    }
}