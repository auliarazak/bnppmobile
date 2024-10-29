<?php

namespace App\Http\Controllers;

use App\Models\Berita;
use Illuminate\Http\Request;

class BeritaApiController extends Controller
{
    public function index()
    {
        // Mengambil semua berita beserta nama pengguna dari data_users, diurutkan dari tanggal terbaru
        $beritas = Berita::with(['user.dataUser'])
            ->orderBy('tgl_berita', 'desc') // Mengurutkan berdasarkan tanggal berita terbaru
            ->get();

        // Format data untuk response
        $result = $beritas->map(function ($berita) {
            return [
                'nama' => $berita->user->dataUser->nama ?? 'Tidak Diketahui', // Menampilkan nama atau 'Tidak Diketahui' jika tidak ada
                'judul_berita' => $berita->judul_berita,
                'deskripsi_berita' => $berita->deskripsi_berita,
                'tgl_berita' => $berita->tgl_berita,
                'foto_berita' => $berita->foto_berita,
            ];
        });

        return response()->json($result);
    }
}
