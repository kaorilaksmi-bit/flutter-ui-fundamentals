import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';

/// Menampilkan Nama, Email, dan Role pengguna yang login.
/// PRAKTIK 4: membaca data dari ProfileProvider (bukan memuat sendiri).
class UserInfoCard extends StatelessWidget {
  const UserInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final pp = context.watch<ProfileProvider>();

    return Card(
      child: Builder(
        builder: (context) {
          if (pp.isLoading) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final p = pp.profile;
          if (pp.error != null || p == null) {
            return const ListTile(
              leading: Icon(Icons.error_outline, color: Colors.red),
              title: Text('Gagal memuat profil'),
              subtitle: Text('Pastikan tabel profiles dan trigger sudah dibuat'),
            );
          }
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