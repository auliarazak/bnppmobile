<?php

namespace App\Http\Controllers;

use App\Models\Peraturan;
use Illuminate\Http\Request;

class PeraturanPemerintahApiController extends Controller
{
    public function index()
    {
        $peraturans = Peraturan::with(['jenisPeraturan'])
            ->where('jenis_peraturan_id', 3)
            ->get()
            ->map(function ($peraturan) {
                return [
                    'peraturan_id' => $peraturan->peraturan_id,
                    'judul_peraturan' => $peraturan->judul_peraturan,
                    'abstrak' => $peraturan->abstrak,
                    'singkatan_jenis' => $peraturan->jenisPeraturan->singkatan_jenis ?? null,
                ];
            });

        // Mengembalikan response JSON
        return response()->json($peraturans);
    }

    public function getDetailed($id)
    {
        $peraturan = Peraturan::with(['user', 'jenisPeraturan', 'teu']) // Adjust the relationships as needed
            ->where('peraturan_id', $id)
            ->first();

        if ($peraturan) {
            return response()->json($peraturan);
        }

        return response()->json(['message' => 'Data not found'], 404);
    }

}
