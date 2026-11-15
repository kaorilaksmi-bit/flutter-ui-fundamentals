import 'package:flutter/material.dart';

/// PRAKTIK 4 (W9): hanya menampilkan [child] jika role pengguna
/// termasuk dalam daftar [allowed]. Selain itu tidak menampilkan apa pun.
///
/// INGAT: ini hanya mengamankan tampilan (UI), bukan database.
class RoleGuard extends StatelessWidget {
  const RoleGuard({
    super.key,
    required this.role,
    required this.allowed,
    required this.child,
  });

  final String role;
  final List<String> allowed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return allowed.contains(role) ? child : const SizedBox.shrink();
  }
}