import '../models/course.dart';
import '../services/course_service.dart';

/// TAHAP 10: Repository menyediakan API data bagi Provider.
/// Provider tidak perlu tahu data berasal dari JSON, API, atau database.
class CourseRepository {
  final CourseService service;

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }
}