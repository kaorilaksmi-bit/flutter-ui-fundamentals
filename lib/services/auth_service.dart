import 'package:supabase_flutter/supabase_flutter.dart';

/// PRAKTIK 1 (W9): semua urusan autentikasi dipusatkan di sini,
/// sehingga halaman (screen) tidak berbicara langsung ke Supabase.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;
  bool get isLoggedIn => currentSession != null;

  /// PRAKTIK 3 (W9): kirim name dan role saat register.
  /// Data ini dibaca oleh trigger handle_new_user di database.
  Future<AuthResponse> register({
    required String email,
    required String password,
    String name = '',
    String role = 'seeker', // 'seeker' atau 'owner'
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name, 'role': role},
    );
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> logout() => _client.auth.signOut();
}