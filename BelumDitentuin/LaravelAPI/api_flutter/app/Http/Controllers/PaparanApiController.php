<?php

namespace App\Http\Controllers;

use App\Models\Paparan;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class PaparanApiController extends Controller
{
    public function cekLevelUser($user_id)
    {
        // Cari user berdasarkan ID
        $user = User::find($user_id);

        // Periksa apakah user ditemukan
        if (!$user) {
            return response()->json([
                'status' => 'error',
                'message' => 'User not found'
            ], 404);
        }

        // Kembalikan level user
        return response()->json([
            'status' => 'success',
            'level_user' => $user->level_user
        ]);
    }

    public function PPKA(Request $request)
    {
        $userId = $request->input('user_id');
        $jenisPaparanId = $request->input('jenis_paparan_id');

        $user = User::find($userId);

        if (!$user) {
            return response()->json(['error' => 'User not found'], 404);
        }

        $query = Paparan::with(['user.dataUser', 'jenisPaparan'])
            ->where('jenis_paparan_id', 1)
            ->orderBy('paparan_id', 'DESC');

        $paparans = $query->get()
            ->filter(function ($paparan) use ($user) {
                if (in_array($user->level_user, [1, 2])) {
                    return true;
                }

                if ($paparan->tag == 'All') {
                    return true; // Dapat dilihat oleh semua level_user
                }

                // Access control logic
                switch ($paparan->tag) {
                    case 'Data Evaluasi':
                        return $user->level_user == 3;
                    case 'Kerja Sama':
                        return $user->level_user == 4;
                    case 'Program dan Perencanaan':
                        return $user->level_user == 5;
                    default:
                        return true; // Allow access to other tags
                }
            })
            ->map(function ($paparan) {
                return [
                    'paparan_id' => $paparan->paparan_id,
                    'user_id' => $paparan->user->dataUser->nama ?? null,
                    'jenis_paparan_id' => $paparan->jenisPaparan->singkatan_jenis ?? null,
                    'judul_paparan' => $paparan->judul_paparan,
                    'deskripsi_paparan' => $paparan->deskripsi_paparan,
                    'tag' => $paparan->tag,
                    'tgl_pembuatan' => $paparan->tgl_pembuatan,
                    'tgl_upload' => $paparan->tgl_upload,
                    'subjek' => $paparan->subjek,
                    'pembuat' => $paparan->pembuat,
                ];
            });

        return response()->json($paparans);
    }

    public function PBWNKP(Request $request)
    {
        $userId = $request->input('user_id');
        $jenisPaparanId = $request->input('jenis_paparan_id');

        $user = User::find($userId);

        if (!$user) {
            return response()->json(['error' => 'User not found'], 404);
        }

        $query = Paparan::with(['user.dataUser', 'jenisPaparan'])
            ->where('jenis_paparan_id', 2)
            ->orderBy('paparan_id', 'DESC');

        $paparans = $query->get()
            ->filter(function ($paparan) use ($user) {
                if (in_array($user->level_user, [1, 2])) {
                    return true;
                }
                
                if ($paparan->tag == 'All') {
                    return true; // Dapat dilihat oleh semua level_user
                }

                // Access control logic
                switch ($paparan->tag) {
                    case 'Data Evaluasi':
                        return $user->level_user == 3;
                    case 'Kerja Sama':
                        return $user->level_user == 4;
                    case 'Program dan Perencanaan':
                        return $user->level_user == 5;
                    default:
                        return true; // Allow access to other tags
                }
            })
            ->map(function ($paparan) {
                return [
                    'paparan_id' => $paparan->paparan_id,
                    'user_id' => $paparan->user->dataUser->nama ?? null,
                    'jenis_paparan_id' => $paparan->jenisPaparan->singkatan_jenis ?? null,
                    'judul_paparan' => $paparan->judul_paparan,
                    'deskripsi_paparan' => $paparan->deskripsi_paparan,
                    'tag' => $paparan->tag,
                    'tgl_pembuatan' => $paparan->tgl_pembuatan,
                    'tgl_upload' => $paparan->tgl_upload,
                    'subjek' => $paparan->subjek,
                    'pembuat' => $paparan->pembuat,
                ];
            });

        return response()->json($paparans);
    }

    public function DI(Request $request)
    {
        $userId = $request->input('user_id');
        $jenisPaparanId = $request->input('jenis_paparan_id');

        $user = User::find($userId);

        if (!$user) {
            return response()->json(['error' => 'User not found'], 404);
        }

        $query = Paparan::with(['user.dataUser', 'jenisPaparan'])
            ->where('jenis_paparan_id', 3)
            ->orderBy('paparan_id', 'DESC');

        $paparans = $query->get()
            ->filter(function ($paparan) use ($user) {
                if (in_array($user->level_user, [1, 2])) {
                    return true;
                }
                
                if ($paparan->tag == 'All') {
                    return true; // Dapat dilihat oleh semua level_user
                }

                // Access control logic
                switch ($paparan->tag) {
                    case 'Data Evaluasi':
                        return $user->level_user == 3;
                    case 'Kerja Sama':
                        return $user->level_user == 4;
                    case 'Program dan Perencanaan':
                        return $user->level_user == 5;
                    default:
                        return true; // Allow access to other tags
                }
            })
            ->map(function ($paparan) {
                return [
                    'paparan_id' => $paparan->paparan_id,
                    'user_id' => $paparan->user->dataUser->nama ?? null,
                    'jenis_paparan_id' => $paparan->jenisPaparan->singkatan_jenis ?? null,
                    'judul_paparan' => $paparan->judul_paparan,
                    'deskripsi_paparan' => $paparan->deskripsi_paparan,
                    'tag' => $paparan->tag,
                    'tgl_pembuatan' => $paparan->tgl_pembuatan,
                    'tgl_upload' => $paparan->tgl_upload,
                    'subjek' => $paparan->subjek,
                    'pembuat' => $paparan->pembuat,
                ];
            });

        return response()->json($paparans);
    }

    public function FKSDLN(Request $request)
    {
        $userId = $request->input('user_id');
        $jenisPaparanId = $request->input('jenis_paparan_id');

        $user = User::find($userId);

        if (!$user) {
            return response()->json(['error' => 'User not found'], 404);
        }

        $query = Paparan::with(['user.dataUser', 'jenisPaparan'])
            ->where('jenis_paparan_id', 4)
            ->orderBy('paparan_id', 'DESC');

        $paparans = $query->get()
            ->filter(function ($paparan) use ($user) {
                if (in_array($user->level_user, [1, 2])) {
                    return true;
                }
                
                if ($paparan->tag == 'All') {
                    return true; // Dapat dilihat oleh semua level_user
                }

                // Access control logic
                switch ($paparan->tag) {
                    case 'Data Evaluasi':
                        return $user->level_user == 3;
                    case 'Kerja Sama':
                        return $user->level_user == 4;
                    case 'Program dan Perencanaan':
                        return $user->level_user == 5;
                    default:
                        return true; // Allow access to other tags
                }
            })
            ->map(function ($paparan) {
                return [
                    'paparan_id' => $paparan->paparan_id,
                    'user_id' => $paparan->user->dataUser->nama ?? null,
                    'jenis_paparan_id' => $paparan->jenisPaparan->singkatan_jenis ?? null,
                    'judul_paparan' => $paparan->judul_paparan,
                    'deskripsi_paparan' => $paparan->deskripsi_paparan,
                    'tag' => $paparan->tag,
                    'tgl_pembuatan' => $paparan->tgl_pembuatan,
                    'tgl_upload' => $paparan->tgl_upload,
                    'subjek' => $paparan->subjek,
                    'pembuat' => $paparan->pembuat,
                ];
            });

        return response()->json($paparans);
    }

    public function LAIN(Request $request)
    {
        $userId = $request->input('user_id');
        $jenisPaparanId = $request->input('jenis_paparan_id');

        $user = User::find($userId);

        if (!$user) {
            return response()->json(['error' => 'User not found'], 404);
        }

        $query = Paparan::with(['user.dataUser', 'jenisPaparan'])
            ->where('jenis_paparan_id', 5)
            ->orderBy('paparan_id', 'DESC');

        $paparans = $query->get()
            ->filter(function ($paparan) use ($user) {
                if (in_array($user->level_user, [1, 2])) {
                    return true;
                }
                
                if ($paparan->tag == 'All') {
                    return true; // Dapat dilihat oleh semua level_user
                }

                // Access control logic
                switch ($paparan->tag) {
                    case 'Data Evaluasi':
                        return $user->level_user == 3;
                    case 'Kerja Sama':
                        return $user->level_user == 4;
                    case 'Program dan Perencanaan':
                        return $user->level_user == 5;
                    default:
                        return true; // Allow access to other tags
                }
            })
            ->map(function ($paparan) {
                return [
                    'paparan_id' => $paparan->paparan_id,
                    'user_id' => $paparan->user->dataUser->nama ?? null,
                    'jenis_paparan_id' => $paparan->jenisPaparan->singkatan_jenis ?? null,
                    'judul_paparan' => $paparan->judul_paparan,
                    'deskripsi_paparan' => $paparan->deskripsi_paparan,
                    'tag' => $paparan->tag,
                    'tgl_pembuatan' => $paparan->tgl_pembuatan,
                    'tgl_upload' => $paparan->tgl_upload,
                    'subjek' => $paparan->subjek,
                    'pembuat' => $paparan->pembuat,
                ];
            });

        return response()->json($paparans);
    }

    public function SSP(Request $request)
    {
        $userId = $request->input('user_id');
        $jenisPaparanId = $request->input('jenis_paparan_id');

        $user = User::find($userId);

        if (!$user) {
            return response()->json(['error' => 'User not found'], 404);
        }

        $query = Paparan::with(['user.dataUser', 'jenisPaparan'])
            ->where('jenis_paparan_id', 6)
            ->orderBy('paparan_id', 'DESC');

        $paparans = $query->get()
            ->filter(function ($paparan) use ($user) {
                if (in_array($user->level_user, [1, 2])) {
                    return true;
                }
                
                if ($paparan->tag == 'All') {
                    return true; // Dapat dilihat oleh semua level_user
                }

                // Access control logic
                switch ($paparan->tag) {
                    case 'Data Evaluasi':
                        return $user->level_user == 3;
                    case 'Kerja Sama':
                        return $user->level_user == 4;
                    case 'Program dan Perencanaan':
                        return $user->level_user == 5;
                    default:
                        return true; // Allow access to other tags
                }
            })
            ->map(function ($paparan) {
                return [
                    'paparan_id' => $paparan->paparan_id,
                    'user_id' => $paparan->user->dataUser->nama ?? null,
                    'jenis_paparan_id' => $paparan->jenisPaparan->singkatan_jenis ?? null,
                    'judul_paparan' => $paparan->judul_paparan,
                    'deskripsi_paparan' => $paparan->deskripsi_paparan,
                    'tag' => $paparan->tag,
                    'tgl_pembuatan' => $paparan->tgl_pembuatan,
                    'tgl_upload' => $paparan->tgl_upload,
                    'subjek' => $paparan->subjek,
                    'pembuat' => $paparan->pembuat,
                ];
            });

        return response()->json($paparans);
    }

    public function index(Request $request)
    {
        $userId = $request->input('user_id');
        $jenisPaparanId = $request->input('jenis_paparan_id');

        $user = User::find($userId);

        if (!$user) {
            return response()->json(['error' => 'User not found'], 404);
        }

        $query = Paparan::with(['user.dataUser', 'jenisPaparan'])
            ->orderBy('paparan_id', 'DESC');

        $paparans = $query->get()
            ->filter(function ($paparan) use ($user) {
                if (in_array($user->level_user, [1, 2])) {
                    return true;
                }
                // Access control logic
                switch ($paparan->tag) {
                    case 'Data Evaluasi':
                        return $user->level_user == 3;
                    case 'Kerja Sama':
                        return $user->level_user == 4;
                    case 'Program dan Perencanaan':
                        return $user->level_user == 5;
                    default:
                        return true; // Allow access to other tags
                }
            })
            ->map(function ($paparan) {
                return [
                    'paparan_id' => $paparan->paparan_id,
                    'user_id' => $paparan->user->dataUser->nama ?? null,
                    'jenis_paparan_id' => $paparan->jenisPaparan->singkatan_jenis ?? null,
                    'judul_paparan' => $paparan->judul_paparan,
                    'deskripsi_paparan' => $paparan->deskripsi_paparan,
                    'tag' => $paparan->tag,
                    'tgl_pembuatan' => $paparan->tgl_pembuatan,
                    'tgl_upload' => $paparan->tgl_upload,
                    'subjek' => $paparan->subjek,
                    'pembuat' => $paparan->pembuat,
                ];
            });

        return response()->json($paparans);
    }

    public function getDetailed($id)
    {
        $paparans = Paparan::with(['User.dataUser']) // Ambil relasi dataUser 
            ->where('paparan_id', $id)
            ->first();

        if ($paparans) {
            return response()->json($paparans);
        }
        return response()->json(['message' => 'Data not found'], 404);
    }

    public function getEdit($id)
    {
        $paparans = Paparan::with(['user', 'jenisPaparan'])
            ->where('paparan_id', $id)
            ->first();

        if ($paparans) {
            return response()->json($paparans);
        }

        return response()->json(['message' => 'Data not found'], 404);
    }

    public function create(Request $request)
    {
        // Validasi input dari request
        $validatedData = $request->validate([
            'user_id' => 'required|exists:users,user_id',
            'jenis_paparan_id' => 'required|exists:jenis_paparans,jenis_paparan_id',
            'judul_paparan' => 'required|string|max:255',
            'deskripsi_paparan' => 'required|string|max:255',
            'tag' => 'required|string',
            'pdf_path' => 'required|string',
            'tgl_pembuatan' => 'nullable|date',
            'tgl_upload' => 'nullable|date',
            'subjek' => 'nullable|string|max:255',
            'pembuat' => 'nullable|string|max:255',
        ]);

        try {
            $paparan = Paparan::create($validatedData);
            Log::info('Paparan berhasil dibuat', ['data' => $paparan]);
            return response()->json($paparan, 200);
        } catch (\Exception $e) {
            Log::error('Error creating paparan: ' . $e->getMessage());
            return response()->json([
                'message' => 'Gagal melakukan input data',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,user_id',
            'jenis_paparan_id' => 'required|exists:jenis_paparans,jenis_paparan_id',
            'judul_paparan' => 'required|string|max:255',
            'deskripsi_paparan' => 'required|string|max:255',
            'tag' => 'required|string',
            'pdf_path' => 'required|string',
            'tgl_pembuatan' => 'nullable|date',
            'tgl_upload' => 'nullable|date',
            'subjek' => 'nullable|string|max:255',
            'pembuat' => 'nullable|string|max:255',
        ]);

        // Check if validation fails
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // Find the peraturan
            $paparan = Paparan::findOrFail($id); // Use findOrFail to automatically handle 404

            // Update the peraturan with validated data
            $paparan->update($request->only([
                'user_id',
                'jenis_paparan_id',
                'judul_paparan',
                'deskripsi_paparan',
                'tag',
                'pdf_path',
                'tgl_pembuatan',
                'tgl_upload',
                'subjek',
                'pembuat',
            ]));

            // Return success response with updated data
            return response()->json([
                'status' => 'success',
                'message' => 'Peraturan updated successfully',
                'data' => $paparan->load(['user'])
            ], 200);
        } catch (\Exception $e) {
            Log::error("Error updating peraturan: " . $e->getMessage());

            // Return error response if something goes wrong
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to update peraturan',
                'error' => 'Internal server error'
            ], 500);
        }
    }

    public function delete($id)
    {
        try {
            $paparan = Paparan::findOrFail($id);
            $paparan->delete();

            return response()->json([
                'status' => 'success',
                'message' => 'Peraturan berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            Log::error("Error deleting peraturan: " . $e->getMessage());

            return response()->json([
                'status' => 'error',
                'message' => 'Gagal menghapus peraturan',
                'error' => 'Internal server error'
            ], 500);
        }
    }
}
