<?php

namespace App\Http\Controllers;

use App\Models\Berita;
use Illuminate\Http\JsonResponse;
use Carbon\Carbon;
use Illuminate\Http\Request;

class BeritaApiController extends Controller
{
    public function getAllBeritas()
    {
        $beritas = Berita::with(['user.dataUser'])
            ->orderBy('tgl_berita', 'desc')
            ->get()
            ->makeHidden('foto_berita');

        // Format data for response
        $result = $beritas->map(function ($berita) {
            return [
                'berita_id' => $berita->berita_id,
                'nama' => $berita->user->dataUser->nama ?? 'Tidak Diketahui',
                'foto_profil' => $berita->user->dataUser->foto_profil ?? null,
                'judul_berita' => $berita->judul_berita,
                'deskripsi_berita' => $berita->deskripsi_berita,
                'tgl_berita' => $berita->tgl_berita,
                'foto_berita' => $berita->foto_berita,
                'status' => $berita->status
            ];
        });
        return response()->json($result);
    }

    public function index()
    {
        // Retrieve news with user and data_users relations, only active news (status = 1)
        $beritas = Berita::with(['user.dataUser'])
            ->where('status', 1)
            ->orderBy('tgl_berita', 'desc')
            ->get()
            ->makeHidden('foto_berita');

        // Format data for response
        $result = $beritas->map(function ($berita) {
            return [
                'berita_id' => $berita->berita_id,
                'nama' => $berita->user->dataUser->nama ?? 'Tidak Diketahui',
                'foto_profil' => $berita->user->dataUser->foto_profil ?? null,
                'judul_berita' => $berita->judul_berita,
                'deskripsi_berita' => $berita->deskripsi_berita,
                'tgl_berita' => $berita->tgl_berita,
                'foto_berita' => $berita->foto_berita,
                'status' => $berita->status
            ];
        });
        return response()->json($result);
    }

    public function terbaru()
    {
        // Retrieve news with user and data_users relations, only active news (status = 1)
        $beritas = Berita::with(['user.dataUser'])
            ->where('status', 1)
            ->orderBy('tgl_berita', 'desc')
            ->get()
            ->makeHidden('foto_berita');

        // Format data for response
        $result = $beritas->map(function ($berita) {
            return [
                'berita_id' => $berita->berita_id,
                'nama' => $berita->user->dataUser->nama ?? 'Tidak Diketahui',
                'foto_profil' => $berita->user->dataUser->foto_profil ?? null,
                'judul_berita' => $berita->judul_berita,
                'deskripsi_berita' => $berita->deskripsi_berita,
                'tgl_berita' => $berita->tgl_berita,
                'foto_berita' => $berita->foto_berita,
                'status' => $berita->status
            ];
        });
        return response()->json($result);
    }

    public function terlama()
    {
        // Retrieve news with user and data_users relations, only active news (status = 1)
        $beritas = Berita::with(['user.dataUser'])
            ->where('status', 1)
            ->orderBy('tgl_berita', 'asc')
            ->get()
            ->makeHidden('foto_berita');

        // Format data for response
        $result = $beritas->map(function ($berita) {
            return [
                'berita_id' => $berita->berita_id,
                'nama' => $berita->user->dataUser->nama ?? 'Tidak Diketahui',
                'foto_profil' => $berita->user->dataUser->foto_profil ?? null,
                'judul_berita' => $berita->judul_berita,
                'deskripsi_berita' => $berita->deskripsi_berita,
                'tgl_berita' => $berita->tgl_berita,
                'foto_berita' => $berita->foto_berita,
                'status' => $berita->status
            ];
        });
        return response()->json($result);
    }

    public function AtoZ()
    {
        // Retrieve news with user and data_users relations, only active news (status = 1)
        $beritas = Berita::with(['user.dataUser'])
            ->where('status', 1)
            ->orderBy('judul_berita', 'desc')
            ->get()
            ->makeHidden('foto_berita');

        // Format data for response
        $result = $beritas->map(function ($berita) {
            return [
                'berita_id' => $berita->berita_id,
                'nama' => $berita->user->dataUser->nama ?? 'Tidak Diketahui',
                'foto_profil' => $berita->user->dataUser->foto_profil ?? null,
                'judul_berita' => $berita->judul_berita,
                'deskripsi_berita' => $berita->deskripsi_berita,
                'tgl_berita' => $berita->tgl_berita,
                'foto_berita' => $berita->foto_berita,
                'status' => $berita->status
            ];
        });
        return response()->json($result);
    }

    public function ZtoA()
    {
        // Retrieve news with user and data_users relations, only active news (status = 1)
        $beritas = Berita::with(['user.dataUser'])
            ->where('status', 1)
            ->orderBy('judul_berita', 'asc')
            ->get()
            ->makeHidden('foto_berita');

        // Format data for response
        $result = $beritas->map(function ($berita) {
            return [
                'berita_id' => $berita->berita_id,
                'nama' => $berita->user->dataUser->nama ?? 'Tidak Diketahui',
                'foto_profil' => $berita->user->dataUser->foto_profil ?? null,
                'judul_berita' => $berita->judul_berita,
                'deskripsi_berita' => $berita->deskripsi_berita,
                'tgl_berita' => $berita->tgl_berita,
                'foto_berita' => $berita->foto_berita,
                'status' => $berita->status
            ];
        });
        return response()->json($result);
    }

    public function detailBerita($id)
    {
        // Find the news by ID with status check
        $berita = Berita::where('berita_id', $id)
            ->first();

        // Check if news exists
        if (!$berita) {
            return response()->json([
                'message' => 'Berita tidak ditemukan'
            ], 404);
        }

        // Format the response data
        $result = [
            'foto_berita' => $berita->foto_berita,
            'judul_berita' => $berita->judul_berita,
            'deskripsi_berita' => $berita->deskripsi_berita,
            'tgl_berita' => $berita->tgl_berita
        ];

        return response()->json($result);
    }

    public function beritaDashboard()
    {
        // Mendapatkan tanggal hari ini
        $today = now();
        // Mendapatkan tanggal seminggu yang lalu
        $weekAgo = now()->subWeek();

        // Mengambil berita dengan relasi user dan data_users, hanya yang aktif (status = 1)
        $beritas = Berita::with(['user.dataUser'])
            ->where('status', 1)
            ->whereBetween('tgl_berita', [$weekAgo, $today])
            ->orderBy('tgl_berita', 'desc')
            ->get()
            ->makeHidden('foto_berita');

        // Format data untuk response
        $result = $beritas->map(function ($berita) {
            return [
                'berita_id' => $berita->berita_id,
                'nama' => $berita->user->dataUser->nama ?? 'Tidak Diketahui',
                'judul_berita' => $berita->judul_berita,
                'deskripsi_berita' => $berita->deskripsi_berita,
                'tgl_berita' => $berita->tgl_berita,
                'foto_berita' => $berita->foto_berita,
                'status' => $berita->status,
                'sisa_hari' => now()->diffInDays(Carbon::parse($berita->tgl_berita)) . ' hari lagi'
            ];
        });

        return response()->json([
            'periode' => [
                'mulai' => $weekAgo->format('Y-m-d'),
                'sampai' => $today->format('Y-m-d')
            ],
            'data' => $result
        ]);
    }

    public function store(Request $request)
    {
        // Validasi input
        $request->validate([
            'user_id' => 'required|exists:users,user_id',
            'judul_berita' => 'required|string|max:255',
            'deskripsi_berita' => 'required|string',
            'tgl_berita' => 'required|date',
            'foto_berita' => 'required|string', // Validasi untuk base64
            'status' => 'required|boolean'
        ]);

        try {
            // Buat record berita baru
            $berita = Berita::create([
                'user_id' => $request->user_id,
                'judul_berita' => $request->judul_berita,
                'deskripsi_berita' => $request->deskripsi_berita,
                'tgl_berita' => $request->tgl_berita,
                'foto_berita' => $request->foto_berita,
                'status' => $request->status
            ]);

            return response()->json([
                'message' => 'Berita berhasil ditambahkan',
                'data' => $berita
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal menambahkan berita',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getEdit($id)
    {
        try {
            $berita = Berita::findOrFail($id);

            return response()->json([
                'message' => 'Data berhasil ditemukan',
                'data' => $berita
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Data tidak ditemukan',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    public function update(Request $request, $id)
    {
        // Validasi input
        $request->validate([
            'user_id' => 'required|exists:users,user_id',
            'judul_berita' => 'required|string|max:255',
            'deskripsi_berita' => 'required|string',
            'tgl_berita' => 'required|date',
            'foto_berita' => 'sometimes|string', // Validasi untuk base64 opsional
            'status' => 'required|boolean'
        ]);

        try {
            $berita = Berita::findOrFail($id);

            // Update semua field
            $berita->user_id = $request->user_id;
            $berita->judul_berita = $request->judul_berita;
            $berita->deskripsi_berita = $request->deskripsi_berita;
            $berita->tgl_berita = $request->tgl_berita;
            $berita->status = $request->status;

            // Update foto jika ada
            if ($request->has('foto_berita')) {
                $berita->foto_berita = $request->foto_berita;
            }

            $berita->save();

            return response()->json([
                'message' => 'Berita berhasil diperbarui',
                'data' => $berita
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal memperbarui berita',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id)
    {
        try {
            $berita = Berita::findOrFail($id);
            $berita->delete();

            return response()->json([
                'message' => 'Berita berhasil dihapus'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal menghapus berita',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function toggleStatus(Request $request, $id): JsonResponse
    {
        try {
            $berita = Berita::findOrFail($id);

            // Validasi request
            $request->validate([
                'status' => 'required|in:0,1',
            ]);

            // Update status berita
            $berita->status = $request->status;
            $berita->save();

            return response()->json([
                'success' => true,
                'message' => 'Status berita berhasil diperbarui',
                'data' => [
                    'berita_id' => $berita->berita_id,
                    'status' => $berita->status,
                ]
            ], 200);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Berita tidak ditemukan',
            ], 404);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak valid',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan pada server',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
