import 'package:supabase_flutter/supabase_flutter.dart';

/// PRAKTIK 6 (W9): pengujian keamanan RLS. Jalankan saat login sebagai USER B.
/// Mencoba mengubah, menghapus, dan menyisipkan data atas nama USER A.
/// Hasil yang benar: semuanya DITOLAK oleh policy database.
Future<List<String>> runSecurityTest({
  required int courseIdMilikUserA,
  required String uuidUserA,
}) async {
  final client = Supabase.instance.client;
  final me = client.auth.currentUser;
  final results = <String>[];

  results.add('Dijalankan sebagai: ${me?.email ?? '-'}');
  if (me?.id == uuidUserA) {
    results.add('PERINGATAN: Anda login sebagai User A. Login sebagai User B!');
    return results;
  }

  // 0. Membaca data (harus diizinkan untuk user yang login)
  try {
    final rows = await client.from('courses').select().eq('id', courseIdMilikUserA);
    results.add(rows.isNotEmpty
        ? '[ALLOWED] SELECT: User B dapat membaca data User A'
        : '[INFO] SELECT: data tidak ditemukan (cek ID course)');
  } on PostgrestException catch (e) {
    results.add('[INFO] SELECT ditolak: ${e.code} - ${e.message}');
  }

  // 1. User B mencoba mengubah data User A -> harus DENIED
  try {
    final updated = await client
        .from('courses')
        .update({'title': 'DIUBAH USER B'})
        .eq('id', courseIdMilikUserA)
        .select();
    results.add(updated.isNotEmpty
        ? '[FAIL] User B berhasil mengubah data User A'
        : '[PASS] UPDATE ditolak oleh RLS (0 baris berubah)');
  } on PostgrestException catch (e) {
    results.add('[PASS] UPDATE ditolak: ${e.code} - ${e.message}');
  }

  // 2. User B mencoba menghapus data User A -> harus DENIED
  try {
    final deleted = await client
        .from('courses')
        .delete()
        .eq('id', courseIdMilikUserA)
        .select();
    results.add(deleted.isNotEmpty
        ? '[FAIL] User B berhasil menghapus data User A'
        : '[PASS] DELETE ditolak oleh RLS (0 baris terhapus)');
  } on PostgrestException catch (e) {
    results.add('[PASS] DELETE ditolak: ${e.code} - ${e.message}');
  }

  // 3. User B mencoba INSERT atas nama User A -> harus ERROR 42501
  try {
    await client.from('courses').insert({
      'owner_id': uuidUserA,
      'code': 'FAKE-RLS',
      'title': 'Course palsu',
      'credits': 1,
      'status': 'planned',
    });
    results.add('[FAIL] INSERT atas nama user lain berhasil');
  } on PostgrestException catch (e) {
    results.add('[PASS] INSERT ditolak: ${e.code} - ${e.message}');
  }

  return results;
}