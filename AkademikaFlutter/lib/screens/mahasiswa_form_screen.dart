import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/mahasiswa.dart';
import '../services/api_service.dart';
import 'dart:io' show File;

class MahasiswaFormScreen extends StatefulWidget {
  const MahasiswaFormScreen({super.key});

  @override
  State<MahasiswaFormScreen> createState() => _MahasiswaFormScreenState();
}

class _MahasiswaFormScreenState extends State<MahasiswaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _namaController = TextEditingController();
  final _jurusanController = TextEditingController();
  final _angkatanController = TextEditingController();
  final _emailController = TextEditingController();
  
  XFile? _imageFile;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    final m = Mahasiswa(
      nim: _nimController.text,
      nama: _namaController.text,
      jurusan: _jurusanController.text,
      angkatan: _angkatanController.text,
      email: _emailController.text,
      status: 'Aktif',
      gpa: '0.00',
      sks: '0',
    );

    try {
      final success = await _apiService.createMahasiswa(m, _imageFile);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mahasiswa berhasil ditambahkan')));
          Navigator.pop(context, true); // return true to indicate success
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  ImageProvider _getImageProvider() {
    if (_imageFile == null) return const NetworkImage('');
    if (kIsWeb) {
      return NetworkImage(_imageFile!.path);
    } else {
      return FileImage(File(_imageFile!.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF316483)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'TAMBAH MAHASISWA',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF316483),
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFDCE3EB), width: 2),
                      image: _imageFile != null
                          ? DecorationImage(image: _getImageProvider(), fit: BoxFit.cover)
                          : null,
                    ),
                    child: _imageFile == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.camera, color: Color(0xFFACB3BA)),
                              SizedBox(height: 4),
                              Text('Upload Foto', style: TextStyle(fontSize: 10, color: Color(0xFFACB3BA))),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildField('NIM', _nimController, LucideIcons.badge),
              const SizedBox(height: 16),
              _buildField('Nama Lengkap', _namaController, LucideIcons.user),
              const SizedBox(height: 16),
              _buildField('Jurusan', _jurusanController, LucideIcons.book),
              const SizedBox(height: 16),
              _buildField('Angkatan', _angkatanController, LucideIcons.calendar),
              const SizedBox(height: 16),
              _buildField('Email', _emailController, LucideIcons.mail, isEmail: true),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF316483),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                      : Text(
                          'Simpan Data',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFACB3BA), size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFDCE3EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFDCE3EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF316483)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }
}
