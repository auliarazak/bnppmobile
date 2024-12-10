<?php

namespace App\Http\Controllers;

use App\Mail\Siranta;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\DB;

class RegisterApiController extends Controller
{
    public function checkAndRegister(Request $request)
    {
        // Validate request
        $request->validate([
            'nip' => 'required',
            'level_user' => 'required',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:6',
            'nama' => 'required',
            'jenis_kelamin' => 'required',
            'tgl_lahir' => 'required|date',
            'no_telp' => 'required',
            'alamat' => 'required'
        ]);

        // Read CSV file
        $csvFile = public_path('files/nip.csv');
        $nipFound = false;

        if (($handle = fopen($csvFile, "r")) !== FALSE) {
            while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
                if ($data[0] == $request->nip) {
                    $nipFound = true;
                    break;
                }
            }
            fclose($handle);
        }

        if (!$nipFound) {
            return response()->json(['message' => 'NIP tidak ditemukan'], 404);
        }

        try {
            DB::beginTransaction();

            // Generate verification code
            $kode_verifikasi = rand(100000, 999999);

            // First insert the user and get the ID
            $user_id = DB::table('users')->insertGetId([
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'level_user' => $request->level_user,
                'kode_verifikasi' => $kode_verifikasi,
                'created_at' => now(),
                'updated_at' => now()
            ]);

            // Create user data with the correct user_id
            DB::table('data_users')->insert([
                'nip' => $request->nip,
                'user_id' => $user_id, // Use the obtained user_id
                'nama' => $request->nama,
                'jenis_kelamin' => $request->jenis_kelamin,
                'tgl_lahir' => $request->tgl_lahir,
                'no_telp' => $request->no_telp,
                'alamat' => $request->alamat,
                'created_at' => now(),
                'updated_at' => now()
            ]);

            // Send verification email
            Mail::to($request->email)->send(new Siranta($kode_verifikasi));

            DB::commit();

            return response()->json([
                'message' => 'Registrasi berhasil. Silakan cek email Anda untuk kode verifikasi.',
                'user_id' => $user_id // Return the actual user_id
            ], 201);
        } catch (\Exception $e) {
            DB::rollback();
            return response()->json([
                'message' => 'Terjadi kesalahan saat registrasi',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function verifyEmail(Request $request)
    {
        $request->validate([
            'user_id' => 'required|string', // Add string validation
            'kode_verifikasi' => 'required|string|size:6' // Ensure it's 6 characters
        ]);

        $user = DB::table('users')
            ->where('user_id', $request->user_id)
            ->where('kode_verifikasi', $request->kode_verifikasi)
            ->whereNull('waktu_email_verifikasi') // Only verify unverified emails
            ->first();

        if (!$user) {
            return response()->json(['message' => 'Kode verifikasi tidak valid'], 400);
        }

        DB::table('users')
            ->where('user_id', $request->user_id)
            ->update([
                'waktu_email_verifikasi' => now(),
                'kode_verifikasi' => null,
                'updated_at' => now()
            ]);

        return response()->json(['message' => 'Verifikasi email berhasil'], 200);
    }

    public function resendVerificationCode(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,user_id'
        ]);

        try {
            // Get user data
            $user = DB::table('users')->where('user_id', $request->user_id)->first();

            if (!$user) {
                return response()->json(['message' => 'User tidak ditemukan'], 404);
            }

            // Generate new verification code
            $kode_verifikasi = rand(100000, 999999);

            // Update user with new verification code
            DB::table('users')
                ->where('user_id', $request->user_id)
                ->update([
                    'kode_verifikasi' => $kode_verifikasi,
                    'updated_at' => now()
                ]);

            // Send new verification email
            Mail::to($user->email)->send(new Siranta($kode_verifikasi));

            return response()->json([
                'message' => 'Kode verifikasi baru telah dikirim'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan saat mengirim ulang kode verifikasi',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function reVerifyEmail(Request $request)
    {
        $request->validate([
            'email' => 'required|email'
        ]);

        try {
            // Check if user exists and get verification status
            $user = DB::table('users')
                ->select('user_id', 'email', 'waktu_email_verifikasi')
                ->where('email', $request->email)
                ->first();

            if (!$user) {
                return response()->json([
                    'message' => 'Email tidak terdaftar'
                ], 404);
            }

            // Check if email is already verified
            if ($user->waktu_email_verifikasi !== null) {
                return response()->json([
                    'message' => 'Email sudah terverifikasi',
                    'is_verified' => true
                ], 400);
            }

            // Generate new verification code
            $kode_verifikasi = rand(100000, 999999);

            // Update user with new verification code
            DB::table('users')
                ->where('user_id', $user->user_id)
                ->update([
                    'kode_verifikasi' => $kode_verifikasi,
                    'updated_at' => now()
                ]);

            // Send verification email
            Mail::to($user->email)->send(new Siranta($kode_verifikasi));

            return response()->json([
                'message' => 'Kode verifikasi telah dikirim',
                'user_id' => $user->user_id,
                'is_verified' => false
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan saat memproses permintaan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function verifikasi(Request $request)
    {
        $request->validate([
            'user_id' => 'required',
            'kode_verifikasi' => 'required'
        ]);

        try {
            // Check if user exists and get verification details
            $user = DB::table('users')
                ->select('user_id', 'email', 'kode_verifikasi', 'waktu_email_verifikasi')
                ->where('user_id', $request->user_id)
                ->first();

            if (!$user) {
                return response()->json([
                    'message' => 'User tidak ditemukan'
                ], 404);
            }

            // Check if email is already verified
            if ($user->waktu_email_verifikasi !== null) {
                return response()->json([
                    'message' => 'Email sudah terverifikasi sebelumnya',
                    'is_verified' => true
                ], 400);
            }

            // Verify the verification code
            if ($user->kode_verifikasi != $request->kode_verifikasi) {
                return response()->json([
                    'message' => 'Kode verifikasi tidak valid',
                    'is_verified' => false
                ], 400);
            }

            // Update verification status
            DB::table('users')
                ->where('user_id', $user->user_id)
                ->update([
                    'waktu_email_verifikasi' => now(),
                    'updated_at' => now(),
                    'kode_verifikasi' => null,
                ]);

            return response()->json([
                'message' => 'Email berhasil diverifikasi',
                'is_verified' => true
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Terjadi kesalahan saat memproses verifikasi',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
