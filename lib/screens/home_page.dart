import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/summary_cards.dart';

class HomePage extends StatelessWidget {
  final String studentId;
  final String studentName;

  const HomePage({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Data Manager')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selamat Datang,', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('Course Explorer Dashboard', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text('$studentId - $studentName', style: const TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Menu Utama', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.school, color: Colors.blue),
                title: const Text('Jelajahi Daftar Course'),
                subtitle: const Text('Lihat modul pembelajaran mobile programming'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 20),
            // TAHAP 14: ringkasan jumlah Courses dan Favorites (watch pada Provider)
            const SummaryCards(),
            const SizedBox(height: 20),
            // TAHAP 7: Consumer membatasi rebuild hanya pada daftar favorit
            Consumer<CourseProvider>(
              builder: (context, provider, child) {
                debugPrint('Consumer daftar favorit rebuild');
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final favs = provider.courses.where((c) => provider.isFavorite(c.code)).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Course Favorit (${favs.length})',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (favs.isEmpty) const Text('Belum ada course favorit.'),
                    for (final c in favs)
                      Card(
                        child: ListTile(
                          title: Text(c.title),
                          subtitle: Text(c.code),
                          trailing: IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            // read(): hanya memanggil aksi, tanpa listen
                            onPressed: () => context.read<CourseProvider>().toggleFavorite(c.code),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}