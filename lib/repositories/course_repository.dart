import '../models/course.dart';
import '../services/course_api_service.dart';

/// TAHAP 4 (Pertemuan 7): dependency diganti dari CourseService
/// menjadi CourseApiService; loadCourses() menjadi getCourses().
class CourseRepository {
  final CourseApiService service;

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.getCourses();
  }
}