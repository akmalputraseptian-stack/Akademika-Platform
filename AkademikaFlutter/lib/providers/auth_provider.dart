import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mahasiswa.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  Mahasiswa? _user;
  bool _isLoading = false;
  String? _errorMessage;
  String? _token;
  final ApiService _apiService = ApiService();

  Mahasiswa? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get token => _token;

  Future<bool> login(String nim, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final result = await _apiService.login(nim, password);
      
      if (result['success'] == true) {
        _user = Mahasiswa.fromJson(result['user']);
        _token = result['token'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('nim', nim);
        if (_token != null) await prefs.setString('auth_token', _token!);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception(result['message'] ?? 'NIM atau Password salah');
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String nim, String password, String nama) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _apiService.register(nim, password, nama);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(Mahasiswa updatedData) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _apiService.updateProfile(updatedData);
      if (success) {
        _user = updatedData;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      throw Exception('Gagal memperbarui profil');
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Gagal memperbarui profil: $e";
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('nim');
    await prefs.remove('auth_token');
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('nim')) return;
    final nim = prefs.getString('nim')!;
    _token = prefs.getString('auth_token');
    try {
      _user = await _apiService.getMahasiswaByNim(nim);
      notifyListeners();
    } catch (e) {
      debugPrint('Auto login error: $e');
    }
  }
}
