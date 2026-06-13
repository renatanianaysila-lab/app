<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Materi;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class MateriController extends Controller
{
    public function index()
    {
        $materis = Materi::all();
        return response()->json([
            'success' => true,
            'data' => $materis
        ], 200);
    }

    // 🎯 TAMBAHKAN FUNGSI STORE INI UNTUK MENERIMA INPUT DARI FLUTTER
    public function store(Request $request)
    {
        // 1. Validasi input dari Flutter
        $validator = Validator::make($request->all(), [
            'guru_id'     => 'required',
            'judul'       => 'required|string|max:255',
            'deskripsi'   => 'required|string',
            'video_url'   => 'required|url', // Memastikan formatnya berupa URL/Link valid
        ], [
            'judul.required'     => 'Judul materi wajib diisi.',
            'deskripsi.required' => 'Deskripsi materi wajib diisi.',
            'video_url.required' => 'Link video YouTube wajib diisi.',
            'video_url.url'      => 'Format link video tidak valid.',
        ]);

        // Jika validasi gagal, kembalikan eror ke Flutter
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors'  => $validator->errors()
            ], 422);
        }

        // 2. Simpan ke database menggunakan model Materi
        $materi = Materi::create([
            'guru_id'   => $request->guru_id, // Sesuaikan dengan field relasi guru di tokomu jika ada
            'judul'     => $request->judul,
            'deskripsi' => $request->deskripsi,
            'video_url' => $request->video_url, // Menaruh link youtube ke kolom video_url
        ]);

        // 3. Beri respon sukses ke Flutter
        return response()->json([
            'success' => true,
            'message' => 'Materi berhasil ditambahkan.',
            'data'    => $materi
        ], 201);
    }

    public function show($video_id)
    {
        $realId = str_replace('vid_', '', $video_id);
        $materi = Materi::find($realId);

        if (!$materi) {
            return response()->json([
                'status' => 'error',
                'message' => 'Materi tidak ditemukan.'
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'data' => [
                'id' => $materi->id,
                'title' => $materi->judul,
                'description' => $materi->deskripsi,
                'youtube_url' => $materi->video_url,
                'uploaded_at' => $materi->created_at ? $materi->created_at->diffForHumans() : 'Baru saja'
            ]
        ], 200);
    }
}