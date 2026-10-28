import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';

/// Service yang berkomunikasi dengan backend REST.
class CourseApiService {
  CourseApiService(this.baseUrl);

  final String baseUrl;

  // Nama resource pada endpoint. JSONPlaceholder memakai 'posts'.
  static const String resource = 'posts';

  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/$resource'));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil course (HTTP ${response.statusCode})');
    }

    final List data = jsonDecode(response.body) as List;
    return data
        .map((e) => Course.fromPostJson(e as Map<String, dynamic>))
        .toList();
  }

  /// HTTP POST untuk membuat resource baru.
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

  /// HTTP PUT untuk memperbarui resource (penggantian penuh).
  Future<void> updateCourse(int id, Course course) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$resource/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal memperbarui course (HTTP ${response.statusCode})');
    }
  }
}