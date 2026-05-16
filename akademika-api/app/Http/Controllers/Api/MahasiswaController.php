<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Mahasiswa;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use OpenApi\Attributes as OA;

class MahasiswaController extends Controller
{
    #[OA\Get(
        path: "/mahasiswa",
        summary: "Get all students",
        tags: ["Mahasiswa"],
        responses: [
            new OA\Response(response: 200, description: "Successful operation")
        ]
    )]
    public function index()
    {
        $mahasiswas = Mahasiswa::all();
        return response()->json([
            'success' => true,
            'data' => $mahasiswas
        ]);
    }

    #[OA\Post(
        path: "/mahasiswa",
        summary: "Create new student",
        tags: ["Mahasiswa"],
        requestBody: new OA\RequestBody(
            required: true,
            content: new OA\JsonContent(
                required: ["nim", "nama", "jurusan", "angkatan", "email"],
                properties: [
                    new OA\Property(property: "nim", type: "string"),
                    new OA\Property(property: "nama", type: "string"),
                    new OA\Property(property: "jurusan", type: "string"),
                    new OA\Property(property: "angkatan", type: "string"),
                    new OA\Property(property: "email", type: "string"),
                ]
            )
        ),
        responses: [
            new OA\Response(response: 201, description: "Student created")
        ]
    )]
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nim' => 'required|unique:mahasiswas',
            'nama' => 'required',
            'jurusan' => 'required',
            'angkatan' => 'required',
            'email' => 'required|email',
            'foto' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'password' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()
            ], 400);
        }

        $data = $request->all();

        if (isset($data['password']) && !empty($data['password'])) {
            $data['password'] = \Illuminate\Support\Facades\Hash::make($data['password']);
        } else {
            // Beri password default "123456" jika tidak diisi dari Flutter
            $data['password'] = \Illuminate\Support\Facades\Hash::make('123456');
        }

        if ($request->hasFile('foto')) {
            $image = $request->file('foto');
            $imageName = time() . '.' . $image->extension();
            $image->storeAs('public/profiles', $imageName);
            $data['profilePic'] = asset('storage/profiles/' . $imageName);
        }

        $mahasiswa = Mahasiswa::create($data);

        return response()->json([
            'success' => true,
            'data' => $mahasiswa
        ], 201);
    }

    #[OA\Get(
        path: "/mahasiswa/{id}",
        summary: "Get student by ID",
        tags: ["Mahasiswa"],
        parameters: [
            new OA\Parameter(name: "id", in: "path", required: true, schema: new OA\Schema(type: "integer"))
        ],
        responses: [
            new OA\Response(response: 200, description: "Successful operation"),
            new OA\Response(response: 404, description: "Student not found")
        ]
    )]
    public function show($id)
    {
        $mahasiswa = Mahasiswa::find($id);

        if (!$mahasiswa) {
            return response()->json([
                'success' => false,
                'message' => 'Mahasiswa not found'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $mahasiswa
        ]);
    }

    #[OA\Put(
        path: "/mahasiswa/{id}",
        summary: "Update student",
        tags: ["Mahasiswa"],
        parameters: [
            new OA\Parameter(name: "id", in: "path", required: true, schema: new OA\Schema(type: "integer"))
        ],
        requestBody: new OA\RequestBody(
            required: true,
            content: new OA\JsonContent(
                properties: [
                    new OA\Property(property: "nama", type: "string"),
                    new OA\Property(property: "jurusan", type: "string"),
                    new OA\Property(property: "angkatan", type: "string"),
                    new OA\Property(property: "email", type: "string"),
                ]
            )
        ),
        responses: [
            new OA\Response(response: 200, description: "Student updated"),
            new OA\Response(response: 404, description: "Student not found")
        ]
    )]
    public function update(Request $request, $id)
    {
        $mahasiswa = Mahasiswa::find($id);

        if (!$mahasiswa) {
            return response()->json([
                'success' => false,
                'message' => 'Mahasiswa not found'
            ], 404);
        }

        $mahasiswa->update($request->all());

        return response()->json([
            'success' => true,
            'data' => $mahasiswa
        ]);
    }

    #[OA\Delete(
        path: "/mahasiswa/{id}",
        summary: "Delete student",
        tags: ["Mahasiswa"],
        parameters: [
            new OA\Parameter(name: "id", in: "path", required: true, schema: new OA\Schema(type: "integer"))
        ],
        responses: [
            new OA\Response(response: 200, description: "Student deleted"),
            new OA\Response(response: 404, description: "Student not found")
        ]
    )]
    public function destroy($id)
    {
        $mahasiswa = Mahasiswa::find($id);

        if (!$mahasiswa) {
            return response()->json([
                'success' => false,
                'message' => 'Mahasiswa not found'
            ], 404);
        }

        $mahasiswa->delete();

        return response()->json([
            'success' => true,
            'message' => 'Mahasiswa deleted successfully'
        ]);
    }
}
