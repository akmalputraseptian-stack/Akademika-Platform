import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/mahasiswa.dart';
import '../services/api_service.dart';
import './mahasiswa_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Mahasiswa>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _studentsFuture = _apiService.getAllMahasiswa();
    });
  }

  Future<void> _deleteStudent(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Mahasiswa'),
        content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final res = await _apiService.deleteMahasiswa(id);
        if (res) {
          _refreshList();
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data berhasil dihapus')));
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'DAFTAR MAHASISWA',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF316483),
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshList();
        },
        child: FutureBuilder<List<Mahasiswa>>(
          future: _studentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.alertCircle, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Terjadi kesalahan: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: _refreshList, child: const Text('Coba Lagi')),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Tidak ada data mahasiswa'));
            }

            final students = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final s = students[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(s.profilePic != null && s.profilePic!.isNotEmpty ? s.profilePic! : 'https://picsum.photos/seed/${s.nim}/200'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      s.nama,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2C3339),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(s.nim, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        Text(s.jurusan, style: const TextStyle(fontSize: 12, color: Color(0xFF596066))),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(LucideIcons.moreVertical, size: 20),
                      onSelected: (value) {
                        if (value == 'delete' && s.id != null) {
                          _deleteStudent(s.id!);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(value: 'delete', child: Text('Hapus', style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MahasiswaFormScreen()),
          );
          if (result == true) {
            _refreshList();
          }
        },
        backgroundColor: const Color(0xFF316483),
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }
}
