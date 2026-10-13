import 'package:flutter/foundation.dart';

import 'models/course.dart';
import 'repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  // TAHAP 10: Provider hanya mengenal repository, bukan rootBundle/service.
  CourseProvider(this.repository, {Set<String>? initialFavorites})
      : favorites = {...?initialFavorites};

  final CourseRepository repository;

  /// Daftar course hasil pemanggilan repository.
  List<Course> courses = [];

  /// Kumpulan kode course yang menjadi favorit.
  final Set<String> favorites;

  bool isFavorite(String id) => favorites.contains(id);

  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    notifyListeners();
  }

  Future<void> loadCourses() async {
    courses = await repository.getCourses();
    // Pengujian sementara (UI baru memakai data ini di tahap berikutnya)
    debugPrint('PROVIDER: ${courses.length} course dimuat lewat repository');
    for (final c in courses) {
      debugPrint('PROVIDER: ${c.code} - ${c.title}');
    }
    notifyListeners();
  }
}