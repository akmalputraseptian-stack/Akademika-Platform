import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/mahasiswa.dart';

import '../utils/page_transitions.dart';
import './ktm_digital_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  
  String? _selectedJurusan;
  String? _selectedAngkatan;

  bool _isSaving = false;
  bool _saveSuccess = false;

  final List<String> _jurusanOptions = [
    'Belum diisi',
    'Information Systems',
    'Computer Science',
    'Data Science',
    'Informatika'
  ];

  final List<String> _angkatanOptions = [
    'Belum diisi',
    '2021',
    '2022',
    '2023',
    '2024'
  ];

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user!;
    _namaController = TextEditingController(text: user.nama);
    _emailController = TextEditingController(text: user.email);

    // Pastikan value dari DB ada di dalam list options, jika tidak set ke 'Belum diisi'
    _selectedJurusan = _jurusanOptions.contains(user.jurusan) ? user.jurusan : 'Belum diisi';
    _selectedAngkatan = _angkatanOptions.contains(user.angkatan) ? user.angkatan : 'Belum diisi';
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    setState(() => _isSaving = true);
    
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.user!;

    final updatedUser = Mahasiswa(
      id: user.id,
      nim: user.nim,
      nama: _namaController.text.isNotEmpty ? _namaController.text : user.nama,
      jurusan: _selectedJurusan ?? 'Belum diisi',
      angkatan: _selectedAngkatan ?? 'Belum diisi',
      email: _emailController.text.isNotEmpty ? _emailController.text : user.email,
      status: user.status,
      gpa: user.gpa,
      sks: user.sks,
      profilePic: user.profilePic,
      className: user.className,
    );

    final success = await auth.updateProfile(updatedUser);

    setState(() {
      _isSaving = false;
      if (success) {
        _saveSuccess = true;
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => _saveSuccess = false);
        });
      }
    });

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Gagal menyimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text('Profil Mahasiswa', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: const Color(0xFF316483))),       
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDCE3EB)),
            ),
            child: const Icon(LucideIcons.menu, size: 20, color: Color(0xFF316483)),
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      backgroundImage: NetworkImage(user.profilePic ?? 'https://picsum.photos/seed/user/200'),    
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.primary, 
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),        
                      child: const Icon(LucideIcons.camera, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(user.nama, style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF2C3339))),     
            Text(user.nim, style: GoogleFonts.poppins(color: const Color(0xFF596066), fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            
            // Button KTM Digital
            OutlinedButton.icon(
              onPressed: () => Navigator.push(context, FadeSlidePageRoute(page: const KtmDigitalScreen())),
              icon: const Icon(LucideIcons.creditCard, size: 18),
              label: const Text('Lihat KTM Digital'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            
            const SizedBox(height: 32),

            // Form Container
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0xFFEAEEF4)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_saveSuccess)
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.checkCircle2, color: Colors.green, size: 20),
                          const SizedBox(width: 12),
                          Text('Data berhasil diperbarui!', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.green[800], fontSize: 12)),
                        ],
                      ),
                    ),

                  _buildEditField('NIM (Read Only)', TextEditingController(text: user.nim), LucideIcons.badge, readOnly: true),
                  const SizedBox(height: 16),
                  _buildEditField('Nama Lengkap', _namaController, LucideIcons.user),
                  const SizedBox(height: 16),
                  _buildDropdownField('Program Studi', _selectedJurusan, _jurusanOptions, LucideIcons.graduationCap, (value) {
                    setState(() => _selectedJurusan = value);
                  }),
                  const SizedBox(height: 16),
                  _buildDropdownField('Angkatan', _selectedAngkatan, _angkatanOptions, LucideIcons.calendar, (value) {
                    setState(() => _selectedAngkatan = value);
                  }),
                  
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        shadowColor: colorScheme.primary.withOpacity(0.3),
                      ),
                      child: _isSaving
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : Text('Simpan Perubahan', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () => auth.logout(),
                icon: const Icon(LucideIcons.logOut),
                label: const Text('Keluar dari Akun', style: TextStyle(fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFA83836),
                  side: const BorderSide(color: Color(0xFFA83836), width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, IconData icon, {bool readOnly = false, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF596066), letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: readOnly ? const Color(0xFFF8F9FD) : const Color(0xFFEAEEF4), 
            borderRadius: BorderRadius.circular(16),
            border: readOnly ? Border.all(color: const Color(0xFFEAEEF4)) : null,
          ),   
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 14,
              color: readOnly ? const Color(0xFFACB3BA) : const Color(0xFF2C3339),
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20, color: const Color(0xFFACB3BA)), 
              hintText: hint ?? label,
              hintStyle: const TextStyle(fontWeight: FontWeight.normal, color: Color(0xFFACB3BA), fontSize: 13),
              border: InputBorder.none, 
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18)
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> options, IconData icon, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF596066), letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEAEEF4), 
            borderRadius: BorderRadius.circular(16),
          ),   
          child: DropdownButtonFormField<String>(
            initialValue: value,
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2C3339))),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20, color: const Color(0xFFACB3BA)), 
              border: InputBorder.none, 
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16)
            ),
            icon: const Icon(LucideIcons.chevronDown, color: Color(0xFFACB3BA), size: 20),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    );
  }
}
