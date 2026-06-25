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
            $result = [];

            foreach ($murid as $m) {
                $totalMateri = DB::table('materis')->count();
                $sudahSelesai = DB::table('user_progress')
                    ->where('user_id', $m->murid_id)
                    ->where('is_completed', 1)
                    ->count();

                $result[] = [
                    'murid_id'     => $m->murid_id,
                    'nama_murid'   => $m->nama_murid,
                    'total_materi' => $totalMateri,
                    'selesai'      => $sudahSelesai,
                    'persen'       => $totalMateri > 0
                        ? round(($sudahSelesai / $totalMateri) * 100)
                        : 0,
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