import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/responsive_shell.dart';
import 'services/api_experiment.dart';
import 'services/course_service.dart';

void main() {
  // TAHAP 2 (Pertemuan 7): uji HTTP GET sementara, hasil tampil di Debug Console
  runApiExperiment();

  runApp(
    // TAHAP 6: menyediakan CourseProvider ke seluruh widget di bawahnya
    ChangeNotifierProvider(
      // TAHAP 10: Service -> Repository -> Provider
      create: (_) => CourseProvider(
        CourseRepository(CourseService()),
        initialFavorites: {'MOB02'},
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