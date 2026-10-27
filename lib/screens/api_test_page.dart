import 'package:flutter/material.dart';

import '../constants/student_identity.dart';
import '../models/course.dart';
import '../services/api_experiment.dart';

/// TAHAP 3 (Pertemuan 7): halaman SEMENTARA untuk menampilkan
/// code, title, dan status dari List<Course> hasil API.
class ApiTestPage extends StatelessWidget {
  const ApiTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 3: Course dari API')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(12),
            child: const Text(
              '$studentId - $studentName',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Course>>(
              future: fetchCourseModels(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final courses = snapshot.data!.take(5).toList();
                return ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, i) {
                    final c = courses[i];
                    return ListTile(
                      leading: Text(c.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                      title: Text(c.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('Status: ${c.status}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}