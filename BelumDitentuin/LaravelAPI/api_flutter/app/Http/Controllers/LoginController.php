<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LoginController extends Controller
{
    public function login(Request $request)
    {
        // Validate the incoming request
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        // Attempt to log the user in
        if (Auth::attempt(['email' => $request->email, 'password' => $request->password])) {
            // Check if email is verified
            $user = Auth::user();

            if ($user->waktu_email_verifikasi === null) {
                Auth::logout(); // Logout user karena email belum terverifikasi
                return response()->json([
                    'message' => 'Email belum terverifikasi. Silahkan verifikasi email Anda terlebih dahulu.'
                ], 401);
            }

            // Authentication passed and email verified...
            return response()->json([
                'message' => 'Login successful',
                'user' => $user
            ], 200);
        }

        return response()->json([
            'message' => 'Email atau password salah'
        ], 401);
    }


    public function forgetPassword()
    {
        //
    }
}
