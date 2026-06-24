<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ProgressController extends Controller
{
    public function getProgresSiswa(Request $request)
    {
        $kategoriInput = $request->query('kelas', 'Dasar');

        // Samakan konversi kata dari Flutter ke data SQL kamu
        $kategoriDb = 'Dasar';
        if ($kategoriInput == 'Intermediate' || $kategoriInput == 'Menengah') {
            $kategoriDb = 'Menengah';
        } elseif ($kategoriInput == 'Lanjutan' || $kategoriInput == 'Susah') {
            $kategoriDb = 'Susah';
        }

        $murids = DB::table('murid')->get();
        $allMateris = DB::table('materis')->where('kategori', $kategoriDb)->get();
        $totalMateri = $allMateris->count();

        $dataProgres = [];

        foreach ($murids as $murid) {
            if ($totalMateri == 0) {
                $dataProgres[] = [
                    'nama' => $murid->nama_murid,
                    'overall_progress' => '0%',
                    'details' => [
                        ['title' => 'Materi Belum Tersedia', 'status' => 'Belum ada materi di bab ini', 'percentage' => '0%', 'score' => null]
                    ]
                ];
                continue;
            }

            // Hitung materi selesai berdasarkan data dummy user_id = 1 yang kita masukkan tadi
            $materiSelesaiCount = DB::table('user_progress')
                ->where('user_id', 1) 
                ->whereIn('materi_id', $allMateris->pluck('id'))
                ->where('is_completed', 1)
                ->count();

            $persentase = round(($materiSelesaiCount / $totalMateri) * 100);
            if ($persentase > 100) $persentase = 100;

            $materiPertama = $allMateris->first();
            $judulMateri = $materiPertama ? $materiPertama->judul : 'Materi Pembelajaran';

            $dataProgres[] = [
                'nama' => $murid->nama_murid,
                'overall_progress' => $persentase . '%',
                'details' => [
                    [
                        'title' => 'Menonton: ' . $judulMateri,
                        'status' => $persentase > 0 ? 'Sudah ditonton' : 'Belum selesai',
                        'percentage' => $persentase . '%',
                        'score' => null,
                    ],
                    [
                        'title' => 'Mengerjakan Kuis ' . $kategoriInput,
                        'status' => $persentase == 100 ? 'Selesai dikerjakan' : 'Belum dikerjakan',
                        'percentage' => $persentase == 100 ? '100%' : '0%',
                        'score' => $persentase == 100 ? 'Skor: 95/100' : 'Skor: 0/100',
                    ]
                ]
            ];
        }

        return response()->json([
            'success' => true,
            'data' => $dataProgres
        ], 200);
    }
}