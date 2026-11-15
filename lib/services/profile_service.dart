import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfile {
  final String id;
  final String email;
  final String name;
  final String role; // seeker | owner | admin

  const UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  bool get isSeeker => role == 'seeker';
  bool get isOwner => role == 'owner';
  bool get isAdmin => role == 'admin';

  factory UserProfile.fromMap(Map<String, dynamic> m) => UserProfile(
        id: m['id'] as String,
        email: (m['email'] ?? '') as String,
        name: (m['name'] ?? '') as String,
        role: (m['role'] ?? 'seeker') as String,
      );
}

class ProfileService {
  SupabaseClient get _client => Supabase.instance.client;

  /// Mengambil profile pengguna yang sedang login (currentUser)
  /// beserta role-nya (currentUserRole).
  Future<UserProfile?> getMyProfile() async {
    final user = _client.auth.currentUser; // currentUser
    if (user == null) return null;

    final data = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return data == null ? null : UserProfile.fromMap(data); // currentUserRole
  }
}