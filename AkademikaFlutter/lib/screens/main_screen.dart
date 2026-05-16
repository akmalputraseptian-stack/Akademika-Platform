import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/auth_provider.dart';
import './dashboard_screen.dart';
import './profile_screen.dart';
import './akademik_screen.dart';
import './kalender_screen.dart';
import '../utils/page_transitions.dart';
import './jadwal_screen.dart';
import './ai_screen.dart';
import './student_list_screen.dart';
import './krs_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const KrsScreen(),
    const AkademikScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: _buildDrawer(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildFloatingNavBar(),
    );
  }

  Widget _buildDrawer() {
    final colorScheme = Theme.of(context).colorScheme;
    final user = Provider.of<AuthProvider>(context).user!;

    return Drawer(
      backgroundColor: const Color(0xFFF8F9FD),
      child: Column(
        children: [
          _buildDrawerHeader(user),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildDrawerItem(
                  icon: LucideIcons.layoutGrid, 
                  label: 'Dashboard', 
                  isSelected: _selectedIndex == 0,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 0);
                  }
                ),
                _buildDrawerItem(
                  icon: LucideIcons.bookOpen,
                  label: 'KRS Digital',
                  isSelected: _selectedIndex == 1,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 1);
                  }
                ),
                _buildDrawerItem(
                  icon: LucideIcons.users,
                  label: 'Daftar Mahasiswa',
                  isSelected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, FadeSlidePageRoute(page: const StudentListScreen()));
                  }
                ),
                _buildDrawerItem(
                  icon: LucideIcons.calendar, 
                  label: 'Jadwal Kuliah', 
                  isSelected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, FadeSlidePageRoute(page: const JadwalScreen()));
                  }
                ),
                _buildDrawerItem(
                  icon: LucideIcons.trendingUp, 
                  label: 'Transkrip Nilai', 
                  isSelected: _selectedIndex == 2,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 2);
                  }
                ),
                _buildDrawerItem(
                  icon: LucideIcons.calendarClock, 
                  label: 'Kalender Akademik', 
                  isSelected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, FadeSlidePageRoute(page: const KalenderScreen()));
                  }
                ),
                _buildDrawerItem(
                  icon: LucideIcons.sparkles, 
                  label: 'Asisten AI', 
                  isSelected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, FadeSlidePageRoute(page: const AiAssistantScreen()));
                  }
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextButton.icon(
              onPressed: () => Provider.of<AuthProvider>(context, listen: false).logout(),
              icon: const Icon(LucideIcons.logOut, color: Color(0xFFA83836)),
              label: const Text('Logout Sesi', style: TextStyle(color: Color(0xFFA83836), fontWeight: FontWeight.bold)),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                backgroundColor: const Color(0xFFA83836).withOpacity(0.05),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(user) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDCE3EB)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Image.asset(
              'assets/images/logo.png',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          const Text('AKADEMIKA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF316483), letterSpacing: 1.5)),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String label, required bool isSelected, required VoidCallback onTap}) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant, size: 20),
      title: Text(label, style: TextStyle(color: isSelected ? colorScheme.primary : colorScheme.onSurface, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 14)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      selected: isSelected,
      selectedTileColor: colorScheme.primary.withOpacity(0.05),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      height: 100,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, LucideIcons.home, 'Beranda'),
                _buildNavItem(1, LucideIcons.bookOpen, 'KRS'),
                _buildNavItem(2, LucideIcons.trendingUp, 'Nilai'),
                _buildNavItem(3, LucideIcons.user, 'Profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
