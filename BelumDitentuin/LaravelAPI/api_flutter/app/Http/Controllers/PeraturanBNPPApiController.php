<?php

namespace App\Http\Controllers;

use App\Models\Peraturan;
use Illuminate\Http\Request;

class PeraturanBNPPApiController extends Controller
{
    public function index()
    {
        // Mengambil semua peraturan dengan jenis_peraturan_id = 4, dan relasi `jenisPeraturan` serta `tipeDokumen`
        $peraturans = Peraturan::with(['jenisPeraturan', 'tipeDokumen'])
                        ->where('jenis_peraturan_id', 4)
                        ->get()
                        ->map(function ($peraturan) {
                            return [
                                'id' => $peraturan->peraturan_id,
                                'judul_peraturan' => $peraturan->judul_peraturan,
                                'abstrak' => $peraturan->abstrak,
                                'singkatan_jenis' => $peraturan->jenisPeraturan->singkatan_jenis ?? null,
                                'nama_tipe' => $peraturan->tipeDokumen->nama_tipe ?? null,
                                // Tambahkan atribut lain yang diperlukan
                            ];
                        });

        // Mengembalikan response JSON
        return response()->json($peraturans);
    }
}
