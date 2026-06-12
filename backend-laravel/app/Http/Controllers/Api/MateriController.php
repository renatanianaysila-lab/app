<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Materi;
use Illuminate\Http\Request;

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