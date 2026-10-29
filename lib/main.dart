import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;
import 'config/supabase_config.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/responsive_shell.dart';
import 'services/course_supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TAHAP 10 (P7): inisialisasi Supabase sebelum runApp().
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // TAHAP 12 (P7): sumber data diganti dari REST ke Supabase.
  // Hanya baris ini yang berubah (service -> repository -> provider).
  final repository = CourseRepository(CourseSupabaseService());

  runApp(
    // TAHAP 6: menyediakan CourseProvider ke seluruh widget di bawahnya
    ChangeNotifierProvider(
      // TAHAP 10: Service -> Repository -> Provider
      create: (_) => CourseProvider(
        repository,
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