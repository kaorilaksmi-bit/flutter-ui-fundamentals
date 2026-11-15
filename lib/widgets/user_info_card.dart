import 'package:flutter/material.dart';

import '../services/profile_service.dart';

/// PRAKTIK 3 (W9): menampilkan Nama, Email, dan Role pengguna yang login.
class UserInfoCard extends StatefulWidget {
  const UserInfoCard({super.key});

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  late final Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    // Dipanggil sekali, bukan dari build()
    _profileFuture = ProfileService().getMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder<UserProfile?>(
        future: _profileFuture,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snap.hasError || snap.data == null) {
            return const ListTile(
              leading: Icon(Icons.error_outline, color: Colors.red),
              title: Text('Gagal memuat profil'),
              subtitle: Text('Pastikan tabel profiles dan trigger sudah dibuat'),
            );
          }
          final p = snap.data!;
          return Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Nama'),
                subtitle: Text(p.name.isEmpty ? '-' : p.name),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(p.email),
              ),
              ListTile(
                leading: const Icon(Icons.badge),
                title: const Text('Role'),
                subtitle: Text(p.role),
              ),
            ],
          );
        },
      ),
    );
  }
}