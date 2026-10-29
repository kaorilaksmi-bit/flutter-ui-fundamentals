import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, Supabase, SupabaseClient;

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

  /// TAHAP 13 (P7): INSERT ke tabel courses.
  /// Mengembalikan Course (row baru) sama seperti versi REST,
  /// sehingga repository tidak berubah.
  @override
  Future<Course> createCourse(Course course) async {
    try {
      final row = await _supabase
          .from('courses')
          .insert(course.toJson()) // id dan created_at diisi oleh database
          .select()
          .single();

      return Course.fromJson(row);
    } on PostgrestException catch (e) {
      // 23505 = pelanggaran unique constraint (kode course sudah dipakai)
      if (e.code == '23505') {
        throw Exception('Kode course sudah digunakan');
      }
      throw Exception('Gagal menyimpan ke database: ${e.message}');
    }
  }

  // Sementara, agar kelas tetap dapat dikompilasi.
  // Dikerjakan pada Tahap 14 dan 15.

  @override
  Future<void> updateCourse(int id, Course course) => throw UnimplementedError();

  @override
  Future<void> deleteCourse(int id) => throw UnimplementedError();
}