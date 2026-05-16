import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mahasiswa.dart';
import '../models/krs.dart';

import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class ApiService {
  // Use 10.0.2.2 for Android Emulator, localhost for Windows/Web
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Menggunakan IP Laptop agar bisa diakses dari HP asli (WiFi sama)
      return 'http://10.0.2.2:8000/api';
    } else {
      return 'http://localhost:8000/api';
    }
  }

  Future<Map<String, dynamic>> login(String nim, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nim': nim, 'password': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'NIM atau Password salah');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server. Pastikan Backend aktif. Error: $e');
    }
  }

  // Helper for authenticated headers
  Map<String, String> _getAuthHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<Krs>> getKrs(String? token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/krs'),
        headers: _getAuthHeaders(token),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        List data = result['data'];
        return data.map((m) => Krs.fromJson(m)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sesi habis atau tidak sah (401). Silakan Logout dan Login kembali.');
      } else {
        throw Exception('Server error (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Gagal terhubung ke server: $e');
    }
  }

  Future<bool> addKrs(Krs krs, String? token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/krs'),
      headers: _getAuthHeaders(token),
      body: jsonEncode(krs.toJson()),
    );
    return response.statusCode == 210;
  }

  Future<List<Mahasiswa>> getAllMahasiswa() async {
    final response = await http.get(Uri.parse('$baseUrl/mahasiswa'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      List data = result['data'];
      return data.map((m) => Mahasiswa.fromJson(m)).toList();
    }
    throw Exception('Gagal mengambil daftar mahasiswa');
  }

  Future<Mahasiswa> getMahasiswaByNim(String nim) async {
    final response = await http.get(Uri.parse('$baseUrl/mahasiswa'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      List data = result['data'];
      var userJson = data.firstWhere((m) => m['nim'] == nim, orElse: () => null);

      if (userJson != null) {
        return Mahasiswa.fromJson(userJson);
      } else {
        return Mahasiswa(
          nim: nim,
          nama: 'User Baru',
          jurusan: 'Belum Diatur',
          angkatan: '2024',
          email: '@student.ac.id'
        );
      }
    }
    throw Exception('Gagal mengambil data mahasiswa');
  }

  Future<bool> createMahasiswa(Mahasiswa m, dynamic imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/mahasiswa'));
    
    request.fields['nim'] = m.nim;
    request.fields['nama'] = m.nama;
    request.fields['jurusan'] = m.jurusan;
    request.fields['angkatan'] = m.angkatan;
    request.fields['email'] = m.email;
    request.fields['status'] = m.status ?? 'Aktif';
    request.fields['gpa'] = m.gpa ?? '0.00';
    request.fields['sks'] = m.sks ?? '0';
    request.fields['class'] = m.className ?? 'A';

    if (imageFile != null) {
      // imageFile must be cast or accessed dynamically, assuming it has a .path if it's a mobile File
      request.files.add(await http.MultipartFile.fromPath('foto', imageFile.path));
    }

    final response = await request.send();
    return response.statusCode == 201;
  }

  Future<void> register(String nim, String password, String nama) async {
    // 1. Daftar ke tabel 'mahasiswa' via API Laravel
    final res = await http.post(
      Uri.parse('$baseUrl/mahasiswa'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nim': nim,
        'nama': nama,
        'jurusan': 'Belum diisi',
        'angkatan': '2024',
        'email': '$nim@student.akademika.ac.id',
        'status': 'Aktif',
        'gpa': '0.00',
        'sks': '0',
        'class': 'A',
        'profilePic': 'https://picsum.photos/seed/$nim/200'
      }),
    );

    if (res.statusCode != 201) {
      final errorData = jsonDecode(res.body);
      throw Exception(errorData['message'] ?? 'Registrasi gagal');
    }
  }

  Future<bool> updateProfile(Mahasiswa updatedData) async {
    if (updatedData.id == null) {
      // If we don't have ID, we need to find it by NIM first
      final getRes = await http.get(Uri.parse('$baseUrl/mahasiswa'));
      if (getRes.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(getRes.body);
        List data = result['data'];
        var userJson = data.firstWhere((m) => m['nim'] == updatedData.nim, orElse: () => null);
        if (userJson != null) {
          final int id = userJson['id'];
          return _performUpdate(id, updatedData);
        }
      }
    } else {
      return _performUpdate(updatedData.id!, updatedData);
    }
    throw Exception('Gagal memperbarui profil di server.');
  }

  Future<bool> _performUpdate(int id, Mahasiswa updatedData) async {
    final putRes = await http.put(
      Uri.parse('$baseUrl/mahasiswa/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData.toJson()),
    );
    
    if (putRes.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> deleteMahasiswa(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/mahasiswa/$id'));
    return res.statusCode == 200;
  }
}
