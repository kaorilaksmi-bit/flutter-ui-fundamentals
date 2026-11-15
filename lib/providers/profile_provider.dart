import 'package:flutter/foundation.dart';

import '../services/profile_service.dart';

/// PRAKTIK 4 (W9): menyimpan profile dan role pengguna yang sedang login
/// agar bisa dipakai oleh banyak screen (cukup dimuat satu kali).
class ProfileProvider extends ChangeNotifier {
  ProfileProvider(this._service);

  final ProfileService _service;

  UserProfile? profile;
  bool isLoading = false;
  String? error;

  /// Jika profile belum ada, dianggap role terendah (seeker).
  String get role => profile?.role ?? 'seeker';
  bool get isOwner => role == 'owner';
  bool get isAdmin => role == 'admin';

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      profile = await _service.getMyProfile(); // null jika belum login
    } catch (e) {
      error = e.toString();
      profile = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Dipanggil saat logout agar role pengguna sebelumnya tidak tersisa.
  void clear() {
    profile = null;
    error = null;
    notifyListeners();
  }
}