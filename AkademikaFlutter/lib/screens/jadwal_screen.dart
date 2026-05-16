import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class JadwalScreen extends StatelessWidget {
  const JadwalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final courses = [
      {'day': 'Senin', 'time': '08:00 - 10:30', 'title': 'Data Structures & Algorithms', 'room': 'Ruang A204', 'lecturer': 'Dr. Budi Santoso'},
      {'day': 'Senin', 'time': '13:00 - 15:30', 'title': 'Web Development', 'room': 'Lab Komputer B', 'lecturer': 'Siti Aminah, M.Kom.'},
      {'day': 'Selasa', 'time': '09:00 - 11:30', 'title': 'Database Systems', 'room': 'Ruang C102', 'lecturer': 'Ahmad Fauzi, Ph.D.'},
      {'day': 'Rabu', 'time': '10:00 - 12:30', 'title': 'Artificial Intelligence', 'room': 'Ruang B301', 'lecturer': 'Prof. Dr. Ir. Wahyu'},
    ];

    final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
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
            child: const Icon(LucideIcons.arrowLeft, size: 20, color: Color(0xFF2C3339)),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'JADWAL KULIAH',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: colorScheme.primary,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jadwal Mingguan',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2C3339),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Semester Genap 2025/2026',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF596066),
              ),
            ),
            const SizedBox(height: 32),
            ...days.map((day) {
              final dayCourses = courses.where((c) => c['day'] == day).toList();
              
              if (dayCourses.isEmpty) {
                 return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFEAEEF4)),
                      ),
                      child: const Center(
                        child: Text('Tidak ada jadwal hari ini.', style: TextStyle(color: Color(0xFFACB3BA), fontWeight: FontWeight.w500)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                 );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...dayCourses.map((course) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFEAEEF4)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFD2E5F5), borderRadius: BorderRadius.circular(8)),
                              child: Text(course['time']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF316483), letterSpacing: 0.5)),
                            ),
                            Row(
                              children: [
                                const Icon(LucideIcons.mapPin, size: 14, color: Color(0xFFACB3BA)),
                                const SizedBox(width: 4),
                                Text(course['room']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF596066))),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(course['title']!, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF2C3339))),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(LucideIcons.user, size: 14, color: Color(0xFFACB3BA)),
                            const SizedBox(width: 6),
                            Text(course['lecturer']!, style: const TextStyle(fontSize: 12, color: Color(0xFF596066))),
                          ],
                        )
                      ],
                    ),
                  )),
                  const SizedBox(height: 24),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
