<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ForumController extends Controller
{
    // 1. AMBIL SEMUA DATA FORUM + BALASANNYA
    public function index()
    {
        $forums = DB::table('forums')
            ->leftJoin('guru', 'forums.pembuat_id', '=', 'guru.guru_id')
            ->leftJoin('murid', 'forums.pembuat_id', '=', 'murid.murid_id')
            ->select(
                'forums.id',
                'forums.konten',
                'forums.media_url',
                'forums.media_type',
                'forums.role',
                'forums.likes_count',
                'forums.created_at',
                DB::raw("CASE WHEN forums.role = 'Guru' THEN guru.nama_guru ELSE murid.nama_murid END as pembuat")
            )
            ->orderBy('forums.created_at', 'desc')
            ->get();

        // Tarik data balasan untuk setiap forum
        foreach ($forums as $forum) {
            $forum->replies = DB::table('forum_replies')
                ->leftJoin('guru', 'forum_replies.pembuat_id', '=', 'guru.guru_id')
                ->leftJoin('murid', 'forum_replies.pembuat_id', '=', 'murid.murid_id')
                ->where('forum_replies.forum_id', $forum->id)
                ->select(
                    'forum_replies.id',
                    'forum_replies.konten',
                    'forum_replies.role',
                    'forum_replies.created_at',
                    DB::raw("CASE WHEN forum_replies.role = 'Guru' THEN guru.nama_guru ELSE murid.nama_murid END as pembuat")
                )
                ->orderBy('forum_replies.created_at', 'asc')
                ->get();
        }

        return response()->json([
            'success' => true,
            'data' => $forums
        ], 200);
    }

    // 2. SIMPAN DATA POSTINGAN UTAMA BARU
    public function store(Request $request)
    {
        $request->validate([
            'pembuat_id' => 'required|string',
            'content' => 'required|string',
            'role' => 'required|string',
            'media' => 'nullable|file|mimes:jpg,jpeg,png,mp4,mov,avi|max:20480',
        ]);

        $mediaUrl = null;
        $mediaType = 'none';

        if ($request->hasFile('media')) {
            $file = $request->file('media');
            $extension = strtolower($file->getClientOriginalExtension());
            $path = $file->storeAs('uploads/forum', time() . '_' . uniqid() . '.' . $extension, 'public');
            $mediaUrl = asset('storage/' . $path);

            if (in_array($extension, ['jpg', 'jpeg', 'png'])) {
                $mediaType = 'image';
            } else if (in_array($extension, ['mp4', 'mov', 'avi'])) {
                $mediaType = 'video';
            }
        }

        DB::table('forums')->insert([
            'pembuat_id' => $request->pembuat_id,
            'judul' => 'Diskusi',
            'konten' => $request->content,
            'media_url' => $mediaUrl,
            'media_type' => $mediaType,
            'role' => $request->role,
            'likes_count' => 0,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return response()->json(['success' => true, 'message' => 'Postingan forum berhasil disimpan!'], 201);
    }

    // 3. FITUR BAGIAN 1: SIMPAN BALASAN/KOMENTAR BARU
    public function storeReply(Request $request, $forumId)
    {
        $request->validate([
            'pembuat_id' => 'required|string',
            'content' => 'required|string',
            'role' => 'required|string',
        ]);

        DB::table('forum_replies')->insert([
            'forum_id' => $forumId,
            'pembuat_id' => $request->pembuat_id,
            'konten' => $request->content,
            'role' => $request->role,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return response()->json(['success' => true, 'message' => 'Balasan berhasil dikirim!'], 201);
    }

    // 4. FITUR BAGIAN 2: TOGGLE LIKE (LIKE ATAU UNLIKE)
    public function toggleLike(Request $request, $id)
    {
        $request->validate([
            'action' => 'required|string|in:like,unlike'
        ]);

        $forum = DB::table('forums')->where('id', $id)->first();
        if (!$forum) {
            return response()->json(['success' => false, 'message' => 'Forum tidak ditemukan'], 404);
        }

        $newLikes = $request->action === 'like' ? $forum->likes_count + 1 : max(0, $forum->likes_count - 1);

        DB::table('forums')->where('id', $id)->update([
            'likes_count' => $newLikes,
            'updated_at' => now()
        ]);

        return response()->json([
            'success' => true,
            'likes_count' => $newLikes
        ], 200);
    }
}