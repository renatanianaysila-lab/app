<?php

namespace App\Http\Controllers;

use App\Models\Materi;
use Illuminate\Http\Request;

class MateriController extends Controller
{
    public function show($video_id)
    {
        // Menghapus prefix 'vid_' jika ada untuk mendapatkan ID asli
        $realId = str_replace('vid_', '', $video_id);

        // Mencari data materi berdasarkan ID asli menggunakan Eloquent Model
        $materi = Materi::find($realId);

        if (!$materi) {
            return response()->json([
                'status' => 'error',
                'message' => 'Materi tidak ditemukan.'
            ], 404);
        }

        // Response JSON disesuaikan dengan kebutuhan form ringkasan aktivitas di Flutter
        return response()->json([
            'status' => 'success',
            'data' => [
                'id' => $materi->id,
                'title' => $materi->judul,       
                'description' => $materi->deskripsi, 
                'youtube_url' => $materi->video_url,
                
                // Tambahan field baru untuk melengkapi form ringkasan aktivitas guru:
                'email_guru' => $materi->email_guru ?? 'guru.isyaratkita@gmail.com', // Mengambil field email guru pengunggah
                'file_format' => $materi->file_format ?? 'Video MP4 / YouTube Stream', // Deteksi format yang di-upload
                'file_size' => $materi->file_size ?? '12.5 MB', // Informasi ukuran berkas
                'uploaded_at' => $materi->created_at ? $materi->created_at->diffForHumans() : 'Baru saja' // Waktu relatif (misal: 5m yang lalu)
            ]
        ], 200);
    }
}