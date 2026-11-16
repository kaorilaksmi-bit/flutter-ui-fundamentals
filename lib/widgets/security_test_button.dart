import 'package:flutter/material.dart';

import '../security_test.dart';

/// PRAKTIK 6 (W9): tombol SEMENTARA untuk menjalankan security test.
/// Hapus dari HomePage setelah pengujian selesai.
class SecurityTestButton extends StatelessWidget {
  const SecurityTestButton({super.key});

  Future<void> _run(BuildContext context) async {
    final idC = TextEditingController();
    final uuidC = TextEditingController();

    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Security Test (login sebagai User B)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: idC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'ID course milik User A'),
            ),
            TextField(
              controller: uuidC,
              decoration: const InputDecoration(labelText: 'UUID User A'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Jalankan'),
          ),
        ],
      ),
    );

    if (go != true || !context.mounted) return;

    final id = int.tryParse(idC.text.trim());
    final uuid = uuidC.text.trim();
    if (id == null || uuid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID course dan UUID User A wajib diisi')),
      );
      return;
    }

    final results = await runSecurityTest(courseIdMilikUserA: id, uuidUserA: uuid);
    for (final line in results) {
      debugPrint(line);
    }
    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hasil Security Test'),
        content: SingleChildScrollView(child: Text(results.join('\n\n'))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _run(context),
      icon: const Icon(Icons.security),
      label: const Text('Security Test (sementara)'),
    );
  }
}