import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class KalenderScreen extends StatelessWidget {
  const KalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final events = [
      {'id': '1', 'date': '21 Apr 2026', 'title': 'Awal Perkuliahan', 'type': 'academic'},
      {'id': '2', 'date': '01 Mei 2026', 'title': 'Hari Buruh', 'type': 'holiday'},
      {'id': '3', 'date': '15 Mei 2026', 'title': 'UTS Semester Genap', 'type': 'academic'},
      {'id': '4', 'date': '22 Mei 2026', 'title': 'Webinar AI Nasional', 'type': 'event'},
    ];

    final months = ['Apr', 'Mei', 'Jun'];

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
          'KALENDER',
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
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kalender Akademik',
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
            ...months.map((month) {
              final monthEvents = events.where((e) => e['date']!.contains(month)).toList();
              if (monthEvents.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 6, height: 24, decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(4))),
                      const SizedBox(width: 12),
                      Text(
                        '${month == 'Apr' ? 'April' : month == 'Jun' ? 'Juni' : month} 2026',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...monthEvents.map((event) {
                    final dateParts = event['date']!.split(' ');
                    final day = dateParts[0];
                    final mon = dateParts[1];
                    
                    Color typeColor;
                    if (event['type'] == 'holiday') {
                      typeColor = colorScheme.error;
                    } else if (event['type'] == 'academic') typeColor = colorScheme.primary;
                    else typeColor = Colors.blue;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFEAEEF4)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 64,
                            child: Column(
                              children: [
                                Text(
                                  mon.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFACB3BA),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                Text(
                                  day,
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF2C3339),
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: const Color(0xFFEAEEF4),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event['type']!.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                    color: typeColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  event['title']!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2C3339),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
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
