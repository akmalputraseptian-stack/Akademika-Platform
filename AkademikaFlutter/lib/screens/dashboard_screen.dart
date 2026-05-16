import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

import '../services/api_service.dart';
import '../models/krs.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  List<Krs> _currentSemesterKrs = [];
  bool _isLoadingKrs = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final data = await _apiService.getKrs(token);
      
      // Filter untuk Semester Aktif saja (Semester 4 sesuai profil)
      setState(() {
        _currentSemesterKrs = data.where((m) => m.semester.contains('4')).toList();
        _isLoadingKrs = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoadingKrs = false);
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Selamat Pagi';
    if (hour >= 12 && hour < 18) return 'Selamat Siang';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: RefreshIndicator(
        onRefresh: _fetchDashboardData,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            _buildAppBar(context, user),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildGreetingSection(user),
                    const SizedBox(height: 32),
                    _buildStatsGrid(user, colorScheme),
                    const SizedBox(height: 40),
                    _buildSectionHeader(LucideIcons.calendar, 'Jadwal Hari Ini'),
                    const SizedBox(height: 16),
                    _buildCourseCard(),
                    const SizedBox(height: 32),
                    _buildSectionHeader(LucideIcons.megaphone, 'Berita Terkini'),
                    const SizedBox(height: 16),
                    _buildNewsCard(),
                    const SizedBox(height: 120), // Padding for floating nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, user) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFFF8F9FD).withOpacity(0.8),
      surfaceTintColor: Colors.transparent,
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
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          Text(
            'AKADEMIKA', 
            style: GoogleFonts.poppins(
              fontSize: 18, 
              fontWeight: FontWeight.w900, 
              color: const Color(0xFF1E3C4F),
              letterSpacing: 0.5,
            )
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDCE3EB)),
            ),
            child: const Icon(LucideIcons.bell, size: 20, color: Color(0xFF596066)),
          ),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 8.0),
          child: CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(user.profilePic ?? 'https://picsum.photos/seed/user/200'),
          ),
        ),
      ],
    );
  }

  Widget _buildGreetingSection(user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${_getGreeting()},', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF2C3339))),
        Text(user.nama.split(' ')[0] + '!', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF316483))),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('${user.jurusan}, Semester 4', style: const TextStyle(color: Color(0xFF596066), fontSize: 16, fontWeight: FontWeight.w500)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: const Border(left: BorderSide(color: Color(0xFF316483), width: 4)),     
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF316483), shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text('STATUS: ${user.status?.toUpperCase() ?? 'AKTIF'}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1, color: Color(0xFF2C3339))),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsGrid(user, ColorScheme colorScheme) {
    int totalSks = _currentSemesterKrs.fold(0, (sum, item) => sum + item.sks);
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard('SKS Terdaftar', totalSks.toString(), LucideIcons.bookOpen, colorScheme.primary),   
        _buildStatCard('IPK / GPA', user.gpa ?? '0.00', LucideIcons.award, colorScheme.secondary),        
        _buildStatCard('Kehadiran', '98%', LucideIcons.checkCircle, colorScheme.tertiary),      
        _buildStatCard('Pesan Baru', '3', LucideIcons.bell, colorScheme.error),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEAEEF4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF2C3339))),
              Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF596066), fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFF316483).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFF316483), size: 20),
        ),
        const SizedBox(width: 12),
        Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF2C3339))),
        const Spacer(),
        const Icon(LucideIcons.chevronRight, color: Color(0xFFACB3BA), size: 20),
      ],
    );
  }

  Widget _buildCourseCard() {
    if (_isLoadingKrs) {
      return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
    }

    if (_currentSemesterKrs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFEAEEF4)),
        ),
        child: const Text('Tidak ada jadwal kuliah hari ini', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
      );
    }

    // Hanya ambil 3 pertama untuk Dashboard
    final displayKrs = _currentSemesterKrs.take(3).toList();

    return Column(
      children: displayKrs.map((item) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFEAEEF4)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFD2E5F5), borderRadius: BorderRadius.circular(16)),
              child: const Icon(LucideIcons.bookOpen, color: Color(0xFF316483)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.namaMatkul, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF2C3339))),
                  const SizedBox(height: 4),
                  Text("${item.kodeMatkul} • ${item.sks} SKS", style: const TextStyle(fontSize: 12, color: Color(0xFF596066))),
                ],
              ),
            ),
            const Icon(LucideIcons.clock, color: Color(0xFFACB3BA), size: 18),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildNewsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEAEEF4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.network('https://picsum.photos/seed/tech/600/300', height: 160, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFD2E5F5), borderRadius: BorderRadius.circular(8)),
                  child: const Text('PENGUMUMAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF316483), letterSpacing: 0.5)),
                ),
                const SizedBox(height: 12),
                Text('Ujian Tengah Semester Genap 2026', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF2C3339))),
                const SizedBox(height: 8),
                const Text('Diberitahukan kepada seluruh mahasiswa bahwa pelaksanaan UTS akan dimulai pada tanggal 15 Mei 2026.', style: TextStyle(fontSize: 13, color: Color(0xFF596066), height: 1.5)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
