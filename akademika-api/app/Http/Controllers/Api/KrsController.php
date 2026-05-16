<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Krs;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class KrsController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $krs = Krs::where('mahasiswa_id', $user->id)->get();
        return response()->json([
            'success' => true,
            'data' => $krs
        ]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'kode_matkul' => 'required',
            'nama_matkul' => 'required',
            'sks' => 'required|integer',
            'semester' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'message' => $validator->errors()], 400);
        }

        $user = $request->user();
        $krs = Krs::create(array_merge($request->all(), ['mahasiswa_id' => $user->id]));

        return response()->json([
            'success' => true,
            'message' => 'Mata kuliah berhasil ditambahkan ke KRS',
            'data' => $krs
        ], 210);
    }

    public function destroy($id)
    {
        $krs = Krs::find($id);
        if (!$krs) return response()->json(['success' => false, 'message' => 'Data tidak ditemukan'], 404);
        
        $krs->delete();
        return response()->json(['success' => true, 'message' => 'Mata kuliah dihapus dari KRS']);
    }
}
