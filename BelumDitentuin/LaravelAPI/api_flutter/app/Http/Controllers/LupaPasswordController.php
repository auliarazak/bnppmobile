<?php

namespace App\Http\Controllers;

use App\Mail\Siranta;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Hash;

class LupaPasswordController extends Controller
{
    public function sendResetCode(Request $request)
    {
        // Validate request
        $request->validate([
            'email' => 'required|email'
        ]);

        try {
            // Check if email exists in database
            $user = DB::table('users')
                ->where('email', $request->email)
                ->first();

            if (!$user) {
                return response()->json([
                    'message' => 'Email tidak terdaftar'
                ], 404);
            }

            // Generate verification code
            $kode_verifikasi = rand(100000, 999999);

            // Update user with verification code
            DB::table('users')
                ->where('user_id', $user->user_id)
                ->update([
                    'kode_verifikasi' => $kode_verifikasi,
                    'updated_at' => now()
                ]);

            // Send verification email
            Mail::to($request->email)->send(new Siranta($kode_verifikasi));

            return response()->json([
                'message' => 'Kode verifikasi telah dikirim ke email Anda',
                'user_id' => $user->user_id
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan saat mengirim kode verifikasi',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function verifyResetCode(Request $request)
    {
        $request->validate([
            'user_id' => 'required',
            'kode_verifikasi' => 'required|string|size:6'
        ]);

        $user = DB::table('users')
            ->where('user_id', $request->user_id)
            ->where('kode_verifikasi', $request->kode_verifikasi)
            ->first();

        if (!$user) {
            return response()->json([
                'message' => 'Kode verifikasi tidak valid'
            ], 400);
        }

        return response()->json([
            'message' => 'Kode verifikasi valid',
            'user_id' => $user->user_id
        ], 200);
    }

    public function resetPassword(Request $request)
    {
        $request->validate([
            'user_id' => 'required',
            'password' => 'required|min:6|confirmed'
        ]);

        try {
            DB::table('users')
                ->where('user_id', $request->user_id)
                ->update([
                    'password' => Hash::make($request->password),
                    'kode_verifikasi' => null,
                    'updated_at' => now()
                ]);

            return response()->json([
                'message' => 'Password berhasil diubah'
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan saat mengubah password',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}