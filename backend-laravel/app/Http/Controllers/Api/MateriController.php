<?php

namespace App\Http\Controllers;

use App\Models\Materi;
use Illuminate\Http\Request;

class MateriController extends Controller
{
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

        // Kita bungkus data agar sesuai dengan nama variabel di Flutter kamu
        return response()->json([
            'id' => $materi->id,
            'title' => $materi->judul,       
            'description' => $materi->deskripsi, 
            'youtube_url' => $materi->video_url, 
        ], 200);
    }
}