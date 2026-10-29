import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, Supabase, SupabaseClient;

import '../models/course.dart';
import 'course_data_source.dart';

/// Sumber data dari database Supabase (tabel courses).
/// TAHAP 17 (P7): error jaringan dan database diterjemahkan menjadi pesan
/// yang informatif agar aplikasi tidak crash dan UI dapat menampilkan retry.
class CourseSupabaseService implements CourseDataSource {
  SupabaseClient get _supabase => Supabase.instance.client;

  static const String _networkMessage =
      'Tidak dapat terhubung ke server. Periksa koneksi internet.';

  /// Mendeteksi kegagalan jaringan (tanpa internet, host tidak ditemukan, dll.).
  bool _isNetworkError(Object e) {
    final text = e.toString();
    return text.contains('SocketException') ||
        text.contains('Failed host lookup') ||
        text.contains('ClientException') ||
        text.contains('Failed to fetch') ||
        text.contains('XMLHttpRequest') ||
        text.contains('Connection') && text.contains('refused');
  }

  @override
  Future<List<Course>> getCourses() async {
    try {
      final data = await _supabase
          .from('courses') // tabel courses
          .select()
          .order('id'); // urut berdasarkan id

      // Konversi response menjadi List<Course>
      return (data as List)
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      // Contoh: PGRST205 (tabel tidak ditemukan), 42501 (ditolak policy)
      throw Exception('Gagal membaca data (${e.code ?? 'error'}): ${e.message}');
    } catch (e) {
      if (_isNetworkError(e)) throw Exception(_networkMessage);
      rethrow; // mis. kesalahan JSON mapping (type/cast error)
    }
  }

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
      // 23514 = pelanggaran CHECK constraint (mis. status atau SKS tidak valid)
      if (e.code == '23514') {
        throw Exception('Data tidak valid menurut aturan database');
      }
      throw Exception('Gagal menyimpan ke database: ${e.message}');
    } catch (e) {
      if (_isNetworkError(e)) throw Exception(_networkMessage);
      rethrow;
    }
  }

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
      if (e.code == '23514') {
        throw Exception('Data tidak valid menurut aturan database');
      }
      throw Exception('Gagal memperbarui di database: ${e.message}');
    } catch (e) {
      if (_isNetworkError(e)) throw Exception(_networkMessage);
      rethrow;
    }
  }

  @override
  Future<void> deleteCourse(int id) async {
    try {
      final rows = await _supabase
          .from('courses')
          .delete()
          .eq('id', id) // hanya baris dengan id ini
          .select();

      if ((rows as List).isEmpty) {
        throw Exception('Course tidak ditemukan atau tidak boleh dihapus');
      }
    } on PostgrestException catch (e) {
      throw Exception('Gagal menghapus di database: ${e.message}');
    } catch (e) {
      if (_isNetworkError(e)) throw Exception(_networkMessage);
      rethrow;
    }
  }
}