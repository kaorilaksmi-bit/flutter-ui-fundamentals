import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';

/// TAHAP 4 (Pertemuan 7): service yang berkomunikasi dengan backend REST.
/// Screen tidak lagi berisi detail request HTTP.
class CourseApiService {
  CourseApiService(this.baseUrl);

  final String baseUrl;

  // Nama resource pada endpoint. JSONPlaceholder memakai 'posts'.
  // Ganti menjadi 'courses' jika memakai endpoint yang berbentuk course.
  static const String resource = 'posts';

  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/$resource'));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil course (HTTP ${response.statusCode})');
    }

    final List data = jsonDecode(response.body) as List;
    return data
        // posts tidak punya code/credits/status, jadi dipetakan lewat fromPostJson
        .map((e) => Course.fromPostJson(e as Map<String, dynamic>))
        .toList();
  }

  /// TAHAP 6 (P7): HTTP POST untuk membuat resource baru.
  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$resource'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Course.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception('Gagal membuat course (HTTP ${response.statusCode})');
  }
}