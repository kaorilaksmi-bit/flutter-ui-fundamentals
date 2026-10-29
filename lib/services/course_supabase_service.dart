import 'package:supabase_flutter/supabase_flutter.dart'
    show Supabase, SupabaseClient;

import '../models/course.dart';
import 'course_data_source.dart';

/// TAHAP 12 (P7): sumber data dari database Supabase (tabel courses).
/// Mengimplementasikan kontrak CourseDataSource yang sama dengan CourseApiService.
class CourseSupabaseService implements CourseDataSource {
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final data = await _supabase
        .from('courses') // tabel courses
        .select()
        .order('id'); // urut berdasarkan id

    // Konversi response menjadi List<Course>
    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Sementara, agar kelas tetap dapat dikompilasi.
  // Dikerjakan pada Tahap 13 sampai 15.
  @override
  Future<Course> createCourse(Course course) => throw UnimplementedError();

  @override
  Future<void> updateCourse(int id, Course course) => throw UnimplementedError();

  @override
  Future<void> deleteCourse(int id) => throw UnimplementedError();
}