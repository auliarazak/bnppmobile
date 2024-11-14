<?php

namespace App\Http\Controllers;

use App\Models\Peraturan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class CrudApiController extends Controller
{
    //for Read
    public function index()
    {
        // Mengambil semua peraturan dengan jenis_peraturan_id = 4, dan relasi `jenisPeraturan` serta `tipeDokumen`
        $peraturans = Peraturan::with(['jenisPeraturan'])
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

    //for Create
    public function create(Request $request)
    {
        // Validasi input dari request
        $validatedData = $request->validate([
            'user_id' => 'required|exists:users,user_id',
            'jenis_peraturan_id' => 'required|exists:jenis_peraturans,jenis_peraturan_id',
            'teu_id' => 'required|exists:t_e_us,teu_id',
            'judul_peraturan' => 'required|string|max:255',
            'nomor_peraturan' => 'required|string|max:255',
            'tahun_peraturan' => 'required|string|max:4',
            'pdf_path' => 'required|string',
            'tempat_penetapan_peraturan' => 'nullable|string|max:255',
            'tgl_penetapan_peraturan' => 'nullable|date',
            'tgl_pengundangan_peraturan' => 'nullable|date',
            'subjek_peraturan' => 'nullable|string|max:255',
            'sumber_peraturan' => 'nullable|string|max:255',
            'status_peraturan' => 'nullable|string|max:255',
            'bahasa_peraturan' => 'nullable|string|max:255',
            'lokasi_peraturan' => 'nullable|string|max:255',
            'bidang_hukum_peraturan' => 'nullable|string|max:255',
            'penanda_tangan_peraturan' => 'nullable|string|max:255',
            'lampiran' => 'nullable|string',
            'abstrak' => 'nullable|string',
            'peraturan_terkait' => 'nullable|string|max:255',
        ]);

        try {
            $peraturan = Peraturan::create($validatedData);
            Log::info('Peraturan berhasil dibuat', ['data' => $peraturan]);
            return response()->json($peraturan, 200);
        } catch (\Exception $e) {
            Log::error('Error creating peraturan: ' . $e->getMessage());
            return response()->json([
                'message' => 'Gagal melakukan input data',
                'error' => $e->getMessage()
            ], 500);
        }
    }


    //for Edit & Delete
    public function AllPeraturan()
    {
        $peraturans = Peraturan::with(['jenisPeraturan'])->get()->makeHidden(['pdf_path']);
        return response()->json($peraturans);
    }

    //for edit
    public function getEdit($id)
    {
        $peraturan = Peraturan::with(['user', 'jenisPeraturan', 'teu'])
            ->where('peraturan_id', $id)
            ->first();

        if ($peraturan) {
            return response()->json($peraturan);
        }

        return response()->json(['message' => 'Data not found'], 404);
    }

    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,user_id',
            'jenis_peraturan_id' => 'required|exists:jenis_peraturans,jenis_peraturan_id',
            'teu_id' => 'required|exists:t_e_us,teu_id',
            'judul_peraturan' => 'required|string|max:255',
            'nomor_peraturan' => 'required|string|max:255',
            'tahun_peraturan' => 'required|string|max:4',
            'pdf_path' => 'required|string',
            'tempat_penetapan_peraturan' => 'nullable|string|max:255',
            'tgl_penetapan_peraturan' => 'nullable|date',
            'tgl_pengundangan_peraturan' => 'nullable|date',
            'subjek_peraturan' => 'nullable|string|max:255',
            'sumber_peraturan' => 'nullable|string|max:255',
            'status_peraturan' => 'nullable|string|max:255',
            'bahasa_peraturan' => 'nullable|string|max:255',
            'lokasi_peraturan' => 'nullable|string|max:255',
            'bidang_hukum_peraturan' => 'nullable|string|max:255',
            'penanda_tangan_peraturan' => 'nullable|string|max:255',
            'lampiran' => 'nullable|string',
            'abstrak' => 'nullable|string',
            'peraturan_terkait' => 'nullable|string|max:255',
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
            $peraturan = Peraturan::findOrFail($id); // Use findOrFail to automatically handle 404

            // Update the peraturan with validated data
            $peraturan->update($request->only([
                'user_id',
                'jenis_peraturan_id',
                'teu_id',
                'judul_peraturan',
                'nomor_peraturan',
                'tahun_peraturan',
                'pdf_path',
                'tempat_penetapan_peraturan',
                'tgl_penetapan_peraturan',
                'tgl_pengundangan_peraturan',
                'subjek_peraturan',
                'sumber_peraturan',
                'status_peraturan',
                'bahasa_peraturan',
                'lokasi_peraturan',
                'bidang_hukum_peraturan',
                'penanda_tangan_peraturan',
                'lampiran',
                'abstrak',
                'peraturan_terkait'
            ]));

            // Return success response with updated data
            return response()->json([
                'status' => 'success',
                'message' => 'Peraturan updated successfully',
                'data' => $peraturan->load(['user', 'jenisPeraturan', 'teu'])
            ], 200);
        } catch (\Exception $e) {
            // Log the error for debugging
            Log::error("Error updating peraturan: " . $e->getMessage());

            // Return error response if something goes wrong
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to update peraturan',
                'error' => 'Internal server error'
            ], 500);
        }
        dd($request->all());
    }

    //for Delete
    public function delete($id)
    {
        try {
            $peraturan = Peraturan::findOrFail($id);
            $peraturan->delete();

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
