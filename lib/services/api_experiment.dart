import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/course.dart';

// TAHAP 2-3 (Pertemuan 7): kode SEMENTARA untuk mencoba HTTP GET dan model.
// Kode ini akan dipindahkan ke service pada Tahap 4.

const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

Future<List<dynamic>> fetchCourses() async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  }
  throw Exception('HTTP ${response.statusCode}');
}

/// TAHAP 3: mengubah List<dynamic> hasil GET menjadi List<Course>.
Future<List<Course>> fetchCourseModels() async {
  final data = await fetchCourses();
  return data
      .map((item) => Course.fromPostJson(item as Map<String, dynamic>))
      .toList();
}

Future<void> runApiExperiment() async {
  try {
    final courses = await fetchCourseModels();
    debugPrint('API: berhasil, jumlah course = ${courses.length}');
    for (final c in courses.take(3)) {
      debugPrint('API: ${c.code} | ${c.title} | ${c.status}');
    }
  } catch (e) {
    debugPrint('API: gagal -> $e');
  }
}