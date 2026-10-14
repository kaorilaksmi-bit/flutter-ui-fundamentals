import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import 'course_detail_page.dart';
import '../widgets/course_card.dart';

class CoursesPage extends StatelessWidget {
  final String studentId;
  final String studentName;

  const CoursesPage({super.key, required this.studentId, required this.studentName});

  int _getCrossAxisCount(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    // watch(): daftar course dibangun ulang saat favorites berubah
    final provider = context.watch<CourseProvider>();

    // TAHAP 11: UI hanya membaca state, tidak mengurus cara mengambil data
    if (provider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Daftar Courses')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (provider.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Daftar Courses')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text('Terjadi kesalahan:\n${provider.error}', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.read<CourseProvider>().loadCourses(),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Courses')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$studentId - $studentName', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(constraints.maxWidth),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: provider.courses.length,
                    itemBuilder: (context, index) {
                      final course = provider.courses[index];
                      // TAHAP 3: CourseCard tidak menyimpan state favorite.
                      // Ia hanya menerima nilai (isFavorite) dan mengirim aksi (callback).
                      return CourseCard(
                        course: course,
                        isFavorite: provider.isFavorite(course.code),
                        // read(): hanya memanggil aksi di dalam callback
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
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}