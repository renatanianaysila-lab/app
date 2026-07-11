<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Murid;
use App\Models\Guru;
use App\Models\Admin;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

class UserController extends Controller
{
    // 1. REGISTER MURID (Otomatis Active)
    public function registerMurid(Request $request)
    {
        $request->validate([
            'nama_murid' => 'required|string|max:100',
            'email_murid' => 'required|email|unique:murid,email_murid',
            'password_murid' => 'required|string|min:8',
        ]);

        $latest = Murid::orderBy('murid_id', 'desc')->first();
        $nextId = $latest ? 'M' . sprintf('%04d', substr($latest->murid_id, 1) + 1) : 'M0001';

        $murid = Murid::create([
            'murid_id' => $nextId,
            'nama_murid' => $request->nama_murid,
            'email_murid' => $request->email_murid,
            'password_murid' => $request->password_murid,
            'status' => 'active',
        ]);

        return response()->json(['status' => 'success', 'message' => 'Registrasi murid berhasil!']);
    }

    // 2. REGISTER GURU (Otomatis Pending)
    public function registerGuru(Request $request)
    {
        $request->validate([
            'nama_guru' => 'required|string|max:100',
            'email_guru' => 'required|email|unique:guru,email_guru',
            'password_guru' => 'required|string|min:8',
        ]);

        $latest = Guru::orderBy('guru_id', 'desc')->first();
        $nextId = $latest ? 'G' . sprintf('%04d', substr($latest->guru_id, 1) + 1) : 'G0001';

        $guru = Guru::create([
            'guru_id' => $nextId,
            'nama_guru' => $request->nama_guru,
            'email_guru' => $request->email_guru,
            'password_guru' => $request->password_guru,
            'status' => 'pending'
        ]);

        return response()->json(['status' => 'success', 'message' => 'Registrasi guru berhasil, menunggu verifikasi Admin.']);
    }

    // 3. REGISTER ADMIN (Otomatis Pending)
    public function registerAdmin(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:100',
            'email' => 'required|email|unique:admin,email',
            'password' => 'required|string|min:8',
        ]);

        Admin::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => $request->password,
        ]);

        return response()->json(['status' => 'success', 'message' => 'Registrasi admin berhasil!']);
    }


    // 4. LOGIN (Deteksi Role & Status)
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = null;
        $role = '';
        $passwordDb = '';

        // Cek di tabel Guru
        if ($guru = Guru::where('email_guru', $request->email)->first()) {
            $user = $guru;
            $role = 'guru';
            $passwordDb = $guru->password_guru;
            
            // Cek status khusus untuk Guru
            if ($guru->status === 'pending') {
                return response()->json(['status' => 'pending', 'message' => 'Akun Guru Anda sedang ditinjau Admin.'], 403);
            }
        } 
        // Cek di tabel Murid
        elseif ($murid = Murid::where('email_murid', $request->email)->first()) {
            $user = $murid;
            $role = 'murid';
            $passwordDb = $murid->password_murid;
        } 
        // Cek di tabel Admin
        elseif ($admin = Admin::where('email', $request->email)->first()) {
            $user = $admin;
            $role = 'admin';
            $passwordDb = $admin->password;
        } else {
            return response()->json(['status' => 'error', 'message' => 'Email tidak ditemukan!'], 401);
        }

        // Cek Password
        if ($request->password != $passwordDb && !Hash::check($request->password, $passwordDb)) {
            return response()->json(['status' => 'error', 'message' => 'Password salah!'], 401);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Login berhasil!',
            'role' => $role,
            'user' => $user
        ]);
    }

    // 5. GET DATA MURID BY ID
    public function getUser($id)
    {
        $murid = Murid::where('murid_id', $id)->first();

        if (!$murid) {
            return response()->json([
                'success' => false,
                'message' => 'Murid tidak ditemukan',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Data murid berhasil diambil',
            'data' => [
                'murid_id' => $murid->murid_id,
                'nama' => $murid->nama_murid,
                'email' => $murid->email_murid,
                'foto_profil' => $murid->foto_profil_murid,
                'tanggal_lahir' => $murid->tanggal_lahir,
            ],
        ], 200);
    }

    public function uploadFoto(Request $request, $id)
    {
    $request->validate([
        'foto' => 'required|image|max:5120', // maks 5MB
    ]);

    $murid = Murid::where('murid_id', $id)->first();

    if (!$murid) {
        return response()->json([
            'success' => false,
            'message' => 'Murid tidak ditemukan',
        ], 404);
    }

    $path = $request->file('foto')->store('profil', 'public');

    $murid->foto_profil_murid = $path;
    $murid->save();

    return response()->json([
        'success' => true,
        'message' => 'Foto profil berhasil diupload',
        'data' => [
            'foto_profil' => asset('storage/' . $path),
        ],
    ], 200);
}
}