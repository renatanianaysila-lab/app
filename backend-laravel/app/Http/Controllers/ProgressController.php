<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ProgressController extends Controller
{
    public function getProgresSiswa(Request $request)
    {
        try {
            $murid = DB::table('murid')->get();
            $totalMateri = DB::table('materis')->count();
            $result = [];

            foreach ($murid as $m) {
                $videoSelesai = DB::table('user_progress')
                    ->where('user_id', $m->murid_id)
                    ->where('is_completed', 1)
                    ->count();

                $skorKuis = DB::table('quiz_scores')
                    ->where('user_id', $m->murid_id)
                    ->avg('skor');

                $persenVideo = $totalMateri > 0
                    ? round(($videoSelesai / $totalMateri) * 100)
                    : 0;

                $persenKuis = $skorKuis ? round($skorKuis) : 0;
                $overall = round(($persenVideo + $persenKuis) / 2);

                $result[] = [
                    'nama'             => $m->nama_murid ?? 'Siswa',
                    'overall_progress' => $overall . '%',
                    'details'          => [
                        [
                            'title'      => 'Nonton Video',
                            'status'     => $videoSelesai . ' dari ' . $totalMateri . ' video selesai',
                            'percentage' => $persenVideo . '%',
                        ],
                        [
                            'title'      => 'Kuis',
                            'status'     => $skorKuis ? 'Sudah mengerjakan kuis' : 'Belum mengerjakan kuis',
                            'percentage' => $persenKuis . '%',
                            'score'      => 'Rata-rata: ' . ($skorKuis ? round($skorKuis) : 0),
                        ],
                    ],
                ];
            }

            return response()->json([
                'success' => true,
                'data'    => $result
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}