import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nimController = TextEditingController();
  final _namaController = TextEditingController();
  final _passController = TextEditingController();

  void _handleRegister() async {
    if (_nimController.text.isEmpty || _namaController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Harap isi semua bidang.'),
          backgroundColor: const Color(0xFFA83836),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        )
      );     
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.register(_nimController.text, _passController.text, _namaController.text);       

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil! Silakan login.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        )
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi gagal. NIM mungkin sudah ada.'),
          backgroundColor: Color(0xFFA83836),
          behavior: SnackBarBehavior.floating,
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFDCE3EB))),
            child: const Icon(LucideIcons.arrowLeft, color: Color(0xFF316483), size: 18),
          ), 
          onPressed: () => Navigator.pop(context)
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Icon(LucideIcons.userPlus, color: colorScheme.primary, size: 32),
            ),
            const SizedBox(height: 24),
            Text('Registrasi Mahasiswa', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF316483), letterSpacing: -0.5)),
            const SizedBox(height: 8),
            const Text('Daftarkan akun portal akademik Anda', style: TextStyle(color: Color(0xFF596066), fontSize: 14)),
            const SizedBox(height: 40),
            
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [BoxShadow(color: const Color(0xFF2C3339).withOpacity(0.06), blurRadius: 40, offset: const Offset(0, 20))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildField('NIM (NOMOR INDUK MAHASISWA)', _nimController, LucideIcons.badge, 'Contoh: 12045678'),
                  const SizedBox(height: 20),
                  _buildField('NAMA LENGKAP', _namaController, LucideIcons.user, 'Masukkan nama sesuai KTP'),
                  const SizedBox(height: 20),
                  _buildField('BUAT PASSWORD', _passController, LucideIcons.lock, 'Minimal 6 karakter', isPass: true),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary, 
                        foregroundColor: colorScheme.onPrimary, 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 8,
                        shadowColor: colorScheme.primary.withOpacity(0.4),
                      ),
                      child: Text('Selesaikan Registrasi', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Kembali ke Login', style: TextStyle(color: Color(0xFF316483), fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, String hint, {bool isPass = false}) {    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF596066), letterSpacing: 1.2)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(color: const Color(0xFFEAEEF4), borderRadius: BorderRadius.circular(16)),   
          child: TextField(
            controller: controller,
            obscureText: isPass,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20, color: const Color(0xFFACB3BA)), 
              hintText: hint,
              hintStyle: const TextStyle(fontWeight: FontWeight.normal, color: Color(0xFFACB3BA), fontSize: 13),
              border: InputBorder.none, 
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18)
            ),
          ),
        ),
      ],
    );
  }
}
