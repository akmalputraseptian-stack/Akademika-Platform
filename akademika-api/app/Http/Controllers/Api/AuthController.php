<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Mahasiswa;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'nim' => 'required',
            'password' => 'required',
        ]);

        $mahasiswa = Mahasiswa::where('nim', $request->nim)->first();

        // Mode Demo: Jika mahasiswa ada, dan (password benar ATAU password yang diketik adalah 123456)
        if ($mahasiswa) {
            $isPasswordValid = false;
            
            if ($mahasiswa->password && Hash::check($request->password, $mahasiswa->password)) {
                $isPasswordValid = true;
            } elseif ($request->password === '123456') {
                // Bypass/Fallback untuk demo jika lupa password atau akun lama tanpa password
                $isPasswordValid = true;
            }

            if ($isPasswordValid) {
                // Hapus token lama jika ada
                $mahasiswa->tokens()->delete();
                $token = $mahasiswa->createToken('auth_token')->plainTextToken;

                return response()->json([
                    'success' => true,
                    'message' => 'Login successful',
                    'token' => $token,
                    'user' => $mahasiswa
                ]);
            }
        }

        return response()->json([
            'success' => false,
            'message' => 'NIM atau Password salah'
        ], 401);
    }
}
