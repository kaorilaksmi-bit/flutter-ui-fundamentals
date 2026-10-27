import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/responsive_shell.dart';
import 'services/course_api_service.dart';

void main() {
  runApp(
    // TAHAP 6: menyediakan CourseProvider ke seluruh widget di bawahnya
    ChangeNotifierProvider(
      // TAHAP 10: Service -> Repository -> Provider
      create: (_) => CourseProvider(
        // TAHAP 4 (P7): sumber data diganti ke REST API
        CourseRepository(CourseApiService('https://jsonplaceholder.typicode.com')),
        initialFavorites: {'POST-2'},
      )..loadCourses(),
      child: const CourseExplorerApp(),
    ),
  );
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ResponsiveShell(),
    );
  }
}