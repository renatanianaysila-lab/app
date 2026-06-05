<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Murid;
use App\Models\Guru;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    
    public function registerMurid(Request $request)
    {
        $request->validate([
            'nama_murid' => 'required|string|max:100',
            'email_murid' => 'required|email|unique:murid,email_murid',
            'password_murid' => 'required|string|min:8',
            'tanggal_lahir' => 'required|date'
        ]);

        
        $latest = Murid::orderBy('murid_id', 'desc')->first();
        $nextId = $latest ? 'M' . sprintf('%04d', substr($latest->murid_id, 1) + 1) : 'M0001';

        $murid = Murid::create([
            'murid_id' => $nextId,
            'nama_murid' => $request->nama_murid,
            'email_murid' => $request->email_murid,
            'password_murid' => $request->password_murid, 
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Akun murid berhasil dibuat!',
            'data' => $murid
        ], 201);
    }

    
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        
        $user = Murid::where('email_murid', $request->email)->first();
        $role = 'murid';

        
        if (!$user) {
            $user = Guru::where('email_guru', $request->email)->first();
            $role = 'guru';
        }

        
        if (!$user) {
            return response()->json(['status' => 'error', 'message' => 'Email tidak terdaftar!'], 401);
        }

        
        $passwordDb = ($role == 'murid') ? $user->password_murid : $user->password_guru;
        
        if ($request->password != $passwordDb && !Hash::check($request->password, $passwordDb)) {
            return response()->json(['status' => 'error', 'message' => 'Password yang Anda masukkan salah!'], 401);
        }

        
        return response()->json([
            'status' => 'success',
            'message' => 'Login berhasil!',
            'token' => 'dummy_token_bypass_success',
            'role' => $role,
            'user' => $user
        ], 200);
    }
}