<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\DataUser;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class UserApiController extends Controller
{
    public function getUserProfile($userId)
    {
        try {
            // Mencari data pengguna berdasarkan user_id
            $dataUser = DataUser::where('user_id', $userId)->select('nip', 'nama', 'foto_profil')->first();

            // Jika data ditemukan, kembalikan respon sukses
            if ($dataUser) {
                return response()->json([
                    'status' => 'success',
                    'data' => [
                        'nip' => $dataUser->nip,
                        'nama' => $dataUser->nama,
                        'foto_profil' => $dataUser->foto_profil
                    ]
                ], 200);
            }

            // Jika data tidak ditemukan, kembalikan respon gagal
            return response()->json([
                'status' => 'error',
                'message' => 'User not found'
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Server error',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getEdit($id)
    {
        $data_user = DataUser::with(['user'])
            ->select('nama', 'jenis_kelamin', 'tgl_lahir', 'no_telp', 'alamat')
            ->where('user_id', $id)
            ->first();

        if ($data_user) {
            return response()->json($data_user);
        }

        return response()->json(['message' => 'Data not found'], 404);
    }

    public function editUserProfil(Request $request, $userId)
    {
        try {
            // Find data user by user_id
            $userData = DataUser::where('user_id', $userId)->first();
            if (!$userData) {
                return response()->json([
                    'status' => false,
                    'message' => 'Data tidak ditemukan'
                ], 404);
            }

            // Update data
            $userData->update([
                'nama' => $request->nama,
                'jenis_kelamin' => $request->jenis_kelamin,
                'tgl_lahir' => $request->tgl_lahir,
                'no_telp' => $request->no_telp,
                'alamat' => $request->alamat
            ]);

            return response()->json([
                'status' => true,
                'message' => 'Profil berhasil diperbarui',
                'data' => $userData
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Gagal memperbarui profil',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function editFotoProfil(Request $request, $userId)
    {
        try {
            // Find data user by user_id
            $userData = DataUser::where('user_id', $userId)->first();
            if (!$userData) {
                return response()->json([
                    'status' => false,
                    'message' => 'Data tidak ditemukan'
                ], 404);
            }

            // Update foto
            $userData->update([
                'foto_profil' => $request->foto_profil
            ]);

            return response()->json([
                'status' => true,
                'message' => 'Foto profil berhasil diperbarui',
                'data' => [
                    'foto_profil' => $userData->foto_profil
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Gagal memperbarui foto profil',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function changePassword(Request $request)
    {
        // Validasi input
        $request->validate([
            'user_id' => 'required|exists:users,user_id',
            'old_password' => 'required',
            'new_password' => 'required|min:6|confirmed'
        ]);

        // Cari user berdasarkan user_id
        $user = User::findOrFail($request->user_id);

        // Cek apakah password lama sesuai
        if (!Hash::check($request->old_password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Password lama tidak sesuai'
            ], 400);
        }

        // Update password
        $user->update([
            'password' => Hash::make($request->new_password)
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Password berhasil diubah'
        ]);
    }

    // public function cekRole(Request $request)
    // {
    //     // Validate the request
    //     $request->validate([
    //         'user_id' => 'required|exists:users,user_id'
    //     ]);

    //     // Get the user
    //     $user = User::findOrFail($request->user_id);

    //     // Ensure role is numeric and within expected range
    //     $role = $user->level_user;
        
    //     // Validate role is numeric and between 1 and 3
    //     if (!is_numeric($role) || $role < 1 || $role > 3) {
    //         return response()->json([
    //             'error' => 'Invalid role',
    //             'role' => null,
    //             'can_edit' => false,
    //             'can_edit_all' => false,
    //             'can_edit_berita' => false
    //         ], 400);
    //     }

    //     // Determine edit permissions based on role
    //     $permissions = match((int)$role) {
    //         1 => [
    //             'can_edit' => true,
    //             'can_edit_all' => true,
    //             'can_edit_berita' => true
    //         ],
    //         2 => [
    //             'can_edit' => true,
    //             'can_edit_all' => false,
    //             'can_edit_berita' => true
    //         ],
    //         3 => [
    //             'can_edit' => false,
    //             'can_edit_all' => false,
    //             'can_edit_berita' => false
    //         ],
    //         default => [
    //             'can_edit' => false,
    //             'can_edit_all' => false,
    //             'can_edit_berita' => false
    //         ]
    //     };

    //     // Return JSON response
    //     return response()->json([
    //         'user_id' => $user->user_id,
    //         'role' => (int)$role,
    //         ...$permissions
    //     ]);
    // }
}
