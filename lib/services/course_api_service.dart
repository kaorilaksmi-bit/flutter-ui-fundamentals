import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';

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
}