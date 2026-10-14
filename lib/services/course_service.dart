import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/course.dart';

/// TAHAP 9: Service bertanggung jawab atas detail teknis sumber data
/// (saat ini JSON asset). Tidak ada kode UI di sini.
class CourseService {
  Future<List<Course>> loadCourses() async {
    // Delay sementara agar loading indicator sempat terlihat (hapus jika tidak perlu)
    await Future<void>.delayed(const Duration(seconds: 2));

    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final list = data['courses'] as List<dynamic>;
    return list
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}