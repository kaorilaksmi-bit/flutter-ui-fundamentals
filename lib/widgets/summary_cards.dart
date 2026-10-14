import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

/// TAHAP 14: ringkasan jumlah Courses dan Favorites pada dashboard Home.
/// Memakai watch() pada satu Provider yang sama dengan screen lain.
class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final courseCount = provider.isLoading ? '...' : '${provider.courses.length}';
    final favoriteCount = '${provider.favorites.length}';

    return Row(
      children: [
        Expanded(child: _StatCard(label: 'Courses', value: courseCount, icon: Icons.school, color: Colors.blue)),
        const SizedBox(width: 12),
        Expanded(child: _StatCard(label: 'Favorites', value: favoriteCount, icon: Icons.favorite, color: Colors.red)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}