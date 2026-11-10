import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthChangeEvent, Supabase;
import 'app_keys.dart';
import 'config/supabase_config.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/login_page.dart';
import 'screens/responsive_shell.dart';
import 'services/auth_service.dart';
import 'services/course_data_source.dart';
import 'services/course_supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TAHAP 10 (P7): inisialisasi Supabase sebelum runApp().
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // PRAKTIK 2 (W9, opsional): mendengarkan perubahan session.
  // Berguna bila session berakhir atau pengguna logout dari tempat lain.
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    debugPrint('Auth event: ${data.event}');
    if (data.event == AuthChangeEvent.signedOut) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  });

  // TAHAP 16 (P7): data source aktif dipilih HANYA di sini.
  // Data source aktif: Supabase
  // (untuk REST: CourseApiService('https://jsonplaceholder.typicode.com'))
  // Satu baris di bawah inilah yang berubah ketika berpindah REST <-> Supabase.
  final CourseDataSource dataSource = CourseSupabaseService();
  final repository = CourseRepository(dataSource);

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
      title: 'Course Data Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      navigatorKey: navigatorKey, // dari app_keys.dart
      scaffoldMessengerKey: messengerKey,
      // PRAKTIK 2 (W9): Check Session
      home: AuthService.instance.isLoggedIn
          ? const ResponsiveShell() // Session ada -> halaman utama
          : const LoginPage(), // Tidak ada session -> Login
    );
  }
}