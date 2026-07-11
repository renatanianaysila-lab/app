<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Materi;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class MateriController extends Controller
{
    /**
     * 1. Menampilkan semua materi
     */
    public function index()
    {
        $materis = Materi::all();
        return response()->json([
            'success' => true,
            'data' => $materis
        ], 200);
    }

    /**
     * 2. Menyimpan materi baru dari Guru (Sudah Fix Kategori & Bebas Typo)
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'guru_id'     => 'required',
            'judul'       => 'required|string|max:255',
            'deskripsi'   => 'required|string',
            'video_url'   => 'required|url', 
            'kategori'    => 'required|in:Dasar,Menengah,Lanjutan', 
        ], [
            'judul.required'     => 'Judul materi wajib diisi.',
            'deskripsi.required' => 'Deskripsi materi wajib diisi.',
            'video_url.required' => 'Link video YouTube wajib diisi.',
            'video_url.url'      => 'Format link video tidak valid.',
            'kategori.required'  => 'Kategori materi wajib dipilih.',
            'kategori.in'        => 'Kategori harus berupa Dasar, Menengah, atau Lanjutan.',
        ]);

        // Jika validasi gagal, kirim error ke Flutter
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors'  => $validator->errors()
            ], 422);
        }

        // Simpan data bersih langsung ke tabel 'materis'
        $materi = Materi::create([
            'guru_id'   => $request->guru_id, 
            'judul'     => $request->judul,
            'deskripsi' => $request->deskripsi,
            'video_url' => $request->video_url, 
            'kategori'  => $request->kategori, 
        ]);

        // Beri respon sukses ke Flutter
        return response()->json([
            'success' => true,
            'message' => 'Materi berhasil ditambahkan.',
            'data'    => $materi
        ], 201);
    }

    /**
     * 3. Menampilkan detail materi berdasarkan video_id
     */
    public function show($video_id)
    {
        // Menghilangkan prefix 'vid_' jika dikirim dari Flutter
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
                'id'          => $materi->id,
                'title'       => $materi->judul,
                'description' => $materi->deskripsi,
                'video_url'   => $materi->video_url,
                'kategori'    => $materi->kategori
            ]
        ], 200);
    }

        /**
     * 4. Ambil daftar level/kategori unik + jumlah materi per level (dinamis, gak di-hardcode)
     * GET /api/materi/levels
     */
    public function levels()
    {
        $levels = DB::table('materis')
            ->select('kategori', DB::raw('COUNT(*) as jumlah_materi'), DB::raw('MIN(id) as urutan'))
            ->groupBy('kategori')
            ->orderBy('urutan', 'asc')
            ->get();

        $result = $levels->values()->map(function ($item, $index) {
            return [
                'level'         => $index + 1,
                'kategori'      => $item->kategori,
                'jumlah_materi' => (int) $item->jumlah_materi,
            ];
        });

        return response()->json(['success' => true, 'data' => $result], 200);
    }
}