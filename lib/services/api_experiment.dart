import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

Future<List<dynamic>> fetchCourses() async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  }
  throw Exception('HTTP ${response.statusCode}');
}

/// Memanggil fetchCourses() lalu mencetak hasilnya ke Debug Console.
Future<void> runApiExperiment() async {
  try {
    final data = await fetchCourses();
    debugPrint('API: berhasil, jumlah item = ${data.length}');
  } catch (e) {
    debugPrint('API: gagal -> $e');
  }
}