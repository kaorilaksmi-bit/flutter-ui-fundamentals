import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

/// TAHAP 13: hanya menampilkan course favorit.
/// Data diambil dari CourseProvider yang sama dengan Courses dan Detail
/// (satu source of truth), sehingga selalu konsisten.
class FavoritesPage extends StatelessWidget {
  final String studentId;
  final String studentName;

  const FavoritesPage({super.key, required this.studentId, required this.studentName});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final favorites = provider.courses.where((c) => provider.isFavorite(c.code)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Course Favorit')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('$studentId - $studentName', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : favorites.isEmpty
                    ? const Center(child: Text('Belum ada course favorit.'))
                    : ListView.builder(
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          final course = favorites[index];
                          return SizedBox(
                            height: 120,
                            child: CourseCard(
                              course: course,
                              isFavorite: true,
                              onFavoriteChanged: () => context.read<CourseProvider>().toggleFavorite(course.code),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CourseDetailPage(
                                      course: course,
                                      studentId: studentId,
                                      studentName: studentName,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}