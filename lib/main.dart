import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/responsive_shell.dart';
import 'services/course_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
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