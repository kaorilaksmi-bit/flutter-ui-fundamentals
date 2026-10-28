import '../models/course.dart';
import '../services/course_data_source.dart';

/// TAHAP 9 (P7): repository hanya mengenal kontrak CourseDataSource,
/// bukan implementasi konkret (REST, Supabase, dan lain-lain).
class CourseRepository {
  CourseRepository(this.dataSource);

  final CourseDataSource dataSource;

  Future<List<Course>> getCourses() => dataSource.getCourses();

  Future<Course> createCourse(Course course) =>
      dataSource.createCourse(course);

  Future<void> updateCourse(int id, Course course) =>
      dataSource.updateCourse(id, course);

  Future<void> deleteCourse(int id) => dataSource.deleteCourse(id);
}