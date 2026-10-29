import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;
import 'config/supabase_config.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/responsive_shell.dart';
import 'services/course_api_service.dart';

// Base URL API latihan (tanpa /posts)
const String apiBaseUrl = 'https://jsonplaceholder.typicode.com';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TAHAP 10 (P7): inisialisasi Supabase sebelum runApp().
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // TAHAP 9 (P7): rakit service -> repository -> provider.
  // Hanya baris ini yang berubah ketika sumber data diganti.
  final repository = CourseRepository(CourseApiService(apiBaseUrl));

  runApp(
    // TAHAP 6: menyediakan CourseProvider ke seluruh widget di bawahnya
    ChangeNotifierProvider(
      // TAHAP 10: Service -> Repository -> Provider
      create: (_) => CourseProvider(
        repository,
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