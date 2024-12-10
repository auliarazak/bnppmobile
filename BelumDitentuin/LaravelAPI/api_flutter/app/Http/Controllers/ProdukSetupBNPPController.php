<?php

namespace App\Http\Controllers;

use App\Models\ProdukSetup;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class ProdukSetupBNPPController extends Controller
{
    public function getList(Request $request)
    { {
            $userId = $request->input('user_id');
            $jenisProdukSetupId = $request->input('jenis_produk_setup_id');

            $user = User::find($userId);

            if (!$user) {
                return response()->json(['error' => 'User not found'], 404);
            }

            $query = ProdukSetup::with(['user.dataUser', 'jenisProdukSetup'])
                ->orderBy('produk_setup_id', 'DESC');

            // Add jenis_paparan_id filter if provided
            if ($jenisProdukSetupId) {
                $query->where('jenis_produk_setup_id', $jenisProdukSetupId);
            }

            $produk_setups = $query->get()
                ->filter(function ($produk_setup) use ($user) {
                    if (in_array($user->level_user, [1, 2])) {
                        return true;
                    }
                    // Access control logic
                    switch ($produk_setup->tag) {
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
                ->map(function ($produk_setup) {
                    return [
                        'produk_setup_id' => $produk_setup->produk_setup_id,
                        'user_id' => $produk_setup->user->dataUser->nama ?? null,
                        'jenis_produk_setup_id' => $produk_setup->jenisProdukSetup->singkatan_jenis ?? null,
                        'judul_setup' => $produk_setup->judul_setup,
                        'deskripsi_setup' => $produk_setup->deskripsi_setup,
                        'tag' => $produk_setup->tag, //datev,, kerma, per
                        'file' => $produk_setup->file,
                        'status' => $produk_setup->status,
                        'tgl_pembuatan' => $produk_setup->tgl_pembuatan,
                        'tgl_upload' => $produk_setup->tgl_upload,
                    ];
                });

            return response()->json($produk_setups);
        }
    }

    public function PPBWNKP(Request $request)
    { {
            $userId = $request->input('user_id');
            $jenisProdukSetupId = $request->input('jenis_produk_setup_id');

            $user = User::find($userId);

            if (!$user) {
                return response()->json(['error' => 'User not found'], 404);
            }

            $query = ProdukSetup::with(['user.dataUser', 'jenisProdukSetup'])
                ->where('jenis_produk_setup_id', 1)
                ->orderBy('produk_setup_id', 'DESC');


            $produk_setups = $query->get()
                ->filter(function ($produk_setup) use ($user) {
                    if (in_array($user->level_user, [1, 2])) {
                        return true;
                    }

                    if ($produk_setup->tag == 'All') {
                        return true; // Dapat dilihat oleh semua level_user
                    }
                    // Access control logic
                    switch ($produk_setup->tag) {
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
                ->map(function ($produk_setup) {
                    return [
                        'produk_setup_id' => $produk_setup->produk_setup_id,
                        'user_id' => $produk_setup->user->dataUser->nama ?? null,
                        'jenis_produk_setup_id' => $produk_setup->jenisProdukSetup->singkatan_jenis ?? null,
                        'judul_setup' => $produk_setup->judul_setup,
                        'deskripsi_setup' => $produk_setup->deskripsi_setup,
                        'tag' => $produk_setup->tag, //datev,, kerma, per
                        'file' => $produk_setup->file,
                        'status' => $produk_setup->status,
                        'tgl_pembuatan' => $produk_setup->tgl_pembuatan,
                        'tgl_upload' => $produk_setup->tgl_upload,
                    ];
                });

            return response()->json($produk_setups);
        }
    }

    public function Panduan(Request $request)
    { {
            $userId = $request->input('user_id');
            $jenisProdukSetupId = $request->input('jenis_produk_setup_id');

            $user = User::find($userId);

            if (!$user) {
                return response()->json(['error' => 'User not found'], 404);
            }

            $query = ProdukSetup::with(['user.dataUser', 'jenisProdukSetup'])
                ->where('jenis_produk_setup_id', 2)
                ->orderBy('produk_setup_id', 'DESC');


            $produk_setups = $query->get()
                ->filter(function ($produk_setup) use ($user) {
                    if (in_array($user->level_user, [1, 2])) {
                        return true;
                    }

                    if ($produk_setup->tag == 'All') {
                        return true; // Dapat dilihat oleh semua level_user
                    }
                    // Access control logic
                    switch ($produk_setup->tag) {
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
                ->map(function ($produk_setup) {
                    return [
                        'produk_setup_id' => $produk_setup->produk_setup_id,
                        'user_id' => $produk_setup->user->dataUser->nama ?? null,
                        'jenis_produk_setup_id' => $produk_setup->jenisProdukSetup->singkatan_jenis ?? null,
                        'judul_setup' => $produk_setup->judul_setup,
                        'deskripsi_setup' => $produk_setup->deskripsi_setup,
                        'tag' => $produk_setup->tag, //datev,, kerma, per
                        'file' => $produk_setup->file,
                        'status' => $produk_setup->status,
                        'tgl_pembuatan' => $produk_setup->tgl_pembuatan,
                        'tgl_upload' => $produk_setup->tgl_upload,
                    ];
                });

            return response()->json($produk_setups);
        }
    }

    public function getDetailed($id)
    {
        $produk_setups = ProdukSetup::with(['User.dataUser']) // Ambil relasi dataUser 
            ->where('produk_setup_id', $id)
            ->first();

        if ($produk_setups) {
            return response()->json($produk_setups);
        }
        return response()->json(['message' => 'Data not found'], 404);
    }

    public function create(Request $request)
    {
        // Validasi input dari request
        $validatedData = $request->validate([
            'user_id' => 'required|exists:users,user_id',
            'jenis_produk_setup_id' => 'required|exists:jenis_produk_setups,jenis_produk_setup_id',
            'judul_setup' => 'required|string|max:255',
            'deskripsi_setup' => 'required|string|max:255',
            'tag' => 'required|string',
            'file' => 'required|string',
            'status' => 'required|boolean',
            'tgl_pembuatan' => 'nullable|date',
            'tgl_upload' => 'nullable|date',
        ]);

        try {
            $produk_setups = ProdukSetup::create($validatedData);
            Log::info('Produk Setup berhasil dibuat', ['data' => $produk_setups]);
            return response()->json($produk_setups, 200);
        } catch (\Exception $e) {
            Log::error('Error creating produk setup: ' . $e->getMessage());
            return response()->json([
                'message' => 'Gagal melakukan input data',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getEdit($id)
    {
        $produk_setups = ProdukSetup::with(['user', 'jenisProdukSetup'])
            ->where('produk_setup_id', $id)
            ->first();

        if ($produk_setups) {
            return response()->json($produk_setups);
        }

        return response()->json(['message' => 'Data not found'], 404);
    }

    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,user_id',
            'jenis_produk_setup_id' => 'required|exists:jenis_produk_setups,jenis_produk_setup_id',
            'judul_setup' => 'required|string|max:255',
            'deskripsi_setup' => 'required|string|max:255',
            'tag' => 'required|string',
            'file' => 'required|string',
            'status' => 'required|boolean',
            'tgl_pembuatan' => 'nullable|date',
            'tgl_upload' => 'nullable|date',
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
            $produk_setups = ProdukSetup::findOrFail($id); // Use findOrFail to automatically handle 404

            // Update the peraturan with validated data
            $produk_setups->update($request->only([
                'user_id',
                'jenis_produk_setup_id',
                'judul_setup',
                'deskripsi_setup',
                'tag',
                'file',
                'status',
                'tgl_pembuatan',
                'tgl_upload',
            ]));

            // Return success response with updated data
            return response()->json([
                'status' => 'success',
                'message' => 'Peraturan updated successfully',
                'data' => $produk_setups->load(['user'])
            ], 200);
        } catch (\Exception $e) {
            Log::error("Error updating produk setup: " . $e->getMessage());

            // Return error response if something goes wrong
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to update produk setup',
                'error' => 'Internal server error'
            ], 500);
        }
    }

    public function delete($id)
    {
        try {
            $produk_setups = ProdukSetup::findOrFail($id);
            $produk_setups->delete();

            return response()->json([
                'status' => 'success',
                'message' => 'Produk Setup berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            Log::error("Error deleting Produk Setup: " . $e->getMessage());

            return response()->json([
                'status' => 'error',
                'message' => 'Gagal menghapus Produk Setup',
                'error' => 'Internal server error'
            ], 500);
        }
    }
}
