<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Comment; 

class CommentController extends Controller
{
    public function getComments($videoId)
    {
        $comments = Comment::where('video_id', $videoId)->orderBy('created_at', 'desc')->get();
        return response()->json($comments, 200);
    }

    public function storeComment(Request $request)
    {
        $request->validate([
            'video_id' => 'required|string',
            'username' => 'required|string',
            'content' => 'required|string',
        ]);

        $comment = Comment::create([
            'video_id' => $request->video_id,
            'username' => $request->username,
            'content' => $request->content,
            'likes_count' => 0
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Komentar berhasil ditambahkan!',
            'data' => $comment
        ], 201);
    }

    public function getDashboardStats()
    {
        // Menghitung total review global
        $totalReviews = Comment::where('rating', '>', 0)->count();

        $averageRating = Comment::where('rating', '>', 0)->avg('rating');
        $averageRating = $averageRating ? round($averageRating, 1) : 0.0;

        return response()->json([
            'success' => true,
            'average_rating' => $averageRating,
            'total_reviews' => $totalReviews
        ], 200);
    }
}