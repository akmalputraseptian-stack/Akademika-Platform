import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import './register_screen.dart';
import '../utils/page_transitions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  final _nimController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _slide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  void _handleLogin() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.login(_nimController.text, _passController.text);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(LucideIcons.alertCircle, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(auth.errorMessage ?? 'Login gagal!')),
            ],
          ),
          backgroundColor: const Color(0xFFA83836),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.all(24),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context).isLoading;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Stack(
        children: [
          Positioned(top: -100, left: -100, child: _buildBlob(400, colorScheme.primary.withOpacity(0.08))),  
          Positioned(bottom: -150, right: -150, child: _buildBlob(500, colorScheme.secondaryContainer.withOpacity(0.3))),
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _opacity,
                child: SlideTransition(
                  position: _slide,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 48),
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2C3339).withOpacity(0.08),
                                blurRadius: 64,
                                offset: const Offset(0, 32),
                                spreadRadius: -16,
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Masuk Akun', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF2C3339))),
                              const SizedBox(height: 32),
                              _buildFieldLabel('USERNAME / NIM'),
                              _buildTextField(controller: _nimController, hint: 'Masukkan NIM Anda', icon: LucideIcons.user),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildFieldLabel('PASSWORD'),
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                                    child: const Text('Lupa Password?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF316483))),
                                  ),
                                ],
                              ),
                              _buildTextField(controller: _passController, hint: 'Masukkan password Anda', icon: LucideIcons.lock, isPassword: true),
                              const SizedBox(height: 32),
                              _buildButton(
                                label: 'Login',
                                isLoading: isLoading,
                                color: colorScheme.primary,
                                textColor: colorScheme.onPrimary,
                                onPressed: _handleLogin,
                                isPrimary: true,
                              ),
                              const SizedBox(height: 12),
                              _buildButton(
                                label: 'Register',
                                isLoading: false,
                                color: colorScheme.secondaryContainer,
                                textColor: colorScheme.onSecondaryContainer,
                                onPressed: () => Navigator.push(context, FadeSlidePageRoute(page: const RegisterScreen())),
                                isPrimary: false,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Column(
                          children: [
                            Text(
                              'Developed by Akmal Putra Septian',
                              style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFFACB3BA), fontWeight: FontWeight.w600, letterSpacing: 0.5),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Teknik Komputer 24 • UNIKOM',
                              style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFFDCE3EB), fontWeight: FontWeight.w500, letterSpacing: 1.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80), child: Container(color: Colors.transparent)),
    );
  }

  Widget _buildHeader() {
    return Column(children: [
      // Logo UNIKOM tanpa kotak/shadow agar menyatu dengan background
      SizedBox(
        width: 120,
        height: 120,
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
        ),
      ),
      const SizedBox(height: 12),
      Text(
        'AKADEMIKA', 
        style: GoogleFonts.poppins(
          fontSize: 22, 
          fontWeight: FontWeight.w900, 
          color: const Color(0xFF1E3C4F),
          letterSpacing: 1.0, // Sedikit renggang agar kemegahan font w900 terlihat
        )
      ),
      const SizedBox(height: 4),
      Text(
        'Portal Akademik Terpadu', 
        style: GoogleFonts.poppins(
          fontSize: 12, 
          color: const Color(0xFF596066), 
          fontWeight: FontWeight.w500, 
          letterSpacing: 0.5
        )
      ),
    ]);
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF596066), letterSpacing: 1.5)),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFEAEEF4), borderRadius: BorderRadius.circular(16)),       
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFFACB3BA), size: 20),
          hintText: hint,
          hintStyle: const TextStyle(fontWeight: FontWeight.normal, color: Color(0xFFACB3BA)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildButton({required String label, required bool isLoading, required Color color, required Color textColor, required VoidCallback onPressed, required bool isPrimary}) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: isPrimary ? 8 : 0,
          shadowColor: isPrimary ? color.withOpacity(0.4) : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.zero,
        ),
        child: isLoading 
          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) 
          : Text(label, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
