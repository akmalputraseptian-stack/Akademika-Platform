import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../models/krs.dart';
import 'dart:collection';

class KrsScreen extends StatefulWidget {
  const KrsScreen({super.key});

  @override
  State<KrsScreen> createState() => _KrsScreenState();
}

class _KrsScreenState extends State<KrsScreen> {
  final ApiService _apiService = ApiService();
  SplayTreeMap<int, List<Krs>> _groupedKrs = SplayTreeMap<int, List<Krs>>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchKrs();
  }

  Future<void> _fetchKrs() async {
    setState(() => _isLoading = true);
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final data = await _apiService.getKrs(token);
      
      // Grouping data by Semester Number
      final Map<int, List<Krs>> grouped = {};
      for (var item in data) {
        // Ekstrak angka dari string "Semester 1" -> 1
        final int semNumber = int.tryParse(item.semester.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        
        if (!grouped.containsKey(semNumber)) {
          grouped[semNumber] = [];
        }
        grouped[semNumber]!.add(item);
      }

      setState(() {
        // SplayTreeMap otomatis mengurutkan berdasarkan Key (angka semester)
        _groupedKrs = SplayTreeMap<int, List<Krs>>.from(grouped);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    int totalSks = 0;
    _groupedKrs.forEach((key, list) => totalSks += list.fold(0, (sum, item) => sum + item.sks));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text('KRS DIGITAL', style: GoogleFonts.poppins(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.2, color: colorScheme.primary)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw, size: 18),
            onPressed: _fetchKrs,
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              _buildSummaryHeader(totalSks, colorScheme),
              Expanded(
                child: _groupedKrs.isEmpty 
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: _groupedKrs.length,
                      itemBuilder: (context, index) {
                        int semNumber = _groupedKrs.keys.elementAt(index);
                        List<Krs> items = _groupedKrs[semNumber]!;
                        return _buildSemesterSection(semNumber, items, colorScheme);
                      },
                    ),
              ),
            ],
          ),
    );
  }

  Widget _buildSummaryHeader(int totalSks, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5), width: 1)),
      ),
      child: Row(
        children: [
          _buildStatItem('Kurikulum', '2024/2025', LucideIcons.layers),
          const Spacer(),
          _buildStatItem('Total SKS', totalSks.toString(), LucideIcons.bookOpen),
          const Spacer(),
          _buildStatItem('Status SKS', 'Aktif', LucideIcons.checkCircle),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF596066)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFFACB3BA))),
      ],
    );
  }

  Widget _buildSemesterSection(int semNumber, List<Krs> items, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Semester Header
        Container(
          margin: const EdgeInsets.only(top: 24, bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.primary.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(LucideIcons.graduationCap, size: 16, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'SEMESTER $semNumber',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: colorScheme.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Text(
                '${items.length} Mata Kuliah',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF596066)),
              ),
            ],
          ),
        ),
        // List of Cards in this semester
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _buildKrsCard(items[index]),
        ),
      ],
    );
  }

  Widget _buildKrsCard(Krs item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEEF4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(LucideIcons.fileText, color: Color(0xFF316483), size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.namaMatkul,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF2C3339)),
                ),
                Text(
                  '${item.kodeMatkul} • ${item.sks} SKS',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF596066), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const Icon(LucideIcons.checkCircle2, color: Colors.green, size: 16),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.fileSearch, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Belum ada data mata kuliah', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
