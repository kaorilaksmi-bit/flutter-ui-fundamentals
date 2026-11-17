import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../app_keys.dart';
import '../firebase_options.dart';

/// PRAKTIK 10: Handler saat aplikasi di BACKGROUND atau TERMINATED.
/// Wajib berada di luar class (top-level function).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('[BACKGROUND] ${message.notification?.title}');
  debugPrint('[BACKGROUND] ${message.notification?.body}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// PRAKTIK 8: Meminta izin notifikasi
  Future<AuthorizationStatus> requestPermission() async {
    if (!_isAndroid) {
      debugPrint('Notification permission dilewati (bukan Android)');
      return AuthorizationStatus.notDetermined;
    }

    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('Notification permission: ${settings.authorizationStatus.name}');
    return settings.authorizationStatus;
  }

  /// PRAKTIK 9: Mendapatkan FCM Token perangkat
  Future<String?> getToken() async {
    if (!_isAndroid) return null;

    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $token');
    return token;
  }

  void listenTokenRefresh(void Function(String token) onRefresh) {
    if (!_isAndroid) return;

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token diperbarui');
      onRefresh(newToken);
    });
  }

  Future<void> saveTokenToSupabase(String token) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    await Supabase.instance.client.from('device_tokens').upsert({
      'token': token,
      'user_id': user.id,
      'platform': defaultTargetPlatform.name,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  /// PRAKTIK 10: Inisialisasi lengkap (Permission, Token, dan Listener Foreground)
  Future<void> init() async {
    if (!_isAndroid) return;

    await requestPermission();
    final token = await getToken();
    if (token != null) {
      // Hapus komentar baris di bawah jika tabel device_tokens sudah dibuat di Supabase:
      // await saveTokenToSupabase(token);
    }
    // listenTokenRefresh(saveTokenToSupabase);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // FOREGROUND: Aplikasi sedang dibuka oleh pengguna
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[FOREGROUND] Notification received');
      debugPrint('title: ${message.notification?.title}');
      debugPrint('body : ${message.notification?.body}');
      debugPrint('data : ${message.data}');

      final title = message.notification?.title ?? 'Notifikasi';
      final body = message.notification?.body ?? '';
      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('$title\n$body'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }
}