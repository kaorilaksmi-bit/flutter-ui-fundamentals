import 'package:flutter/foundation.dart';

import 'models/course.dart';
import 'repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  // TAHAP 10: Provider hanya mengenal repository, bukan rootBundle/service.
  CourseProvider(this.repository, {Set<String>? initialFavorites})
      : favorites = {...?initialFavorites};

  final CourseRepository repository;

  /// TAHAP 11: tiga state async dalam satu state holder.
  List<Course> courses = [];
  bool isLoading = false;
  String? error;

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
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}