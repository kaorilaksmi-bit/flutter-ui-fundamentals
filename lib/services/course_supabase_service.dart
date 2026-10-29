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

  /// TAHAP 14 (P7): UPDATE berdasarkan id.
  /// Signature sama dengan CourseDataSource dan versi REST.
  @override
  Future<void> updateCourse(int id, Course course) async {
    try {
      final rows = await _supabase
          .from('courses')
          .update(course.toJson())
          .eq('id', id) // hanya baris dengan id ini
          .select();

      // Jika tidak ada baris yang berubah (id tidak ada atau ditolak policy),
      // anggap gagal agar tidak terlihat sukses palsu.
      if ((rows as List).isEmpty) {
        throw Exception('Course tidak ditemukan atau tidak boleh diubah');
      }
    } on PostgrestException catch (e) {
      throw Exception('Gagal memperbarui di database: ${e.message}');
    }
  }

  // Sementara, agar kelas tetap dapat dikompilasi.
  // Dikerjakan pada Tahap 15.

  @override
  Future<void> deleteCourse(int id) => throw UnimplementedError();
}