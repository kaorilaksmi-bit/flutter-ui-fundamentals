import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../models/course.dart';
import 'course_form_page.dart';

class CourseDetailPage extends StatefulWidget {
  final Course course;
  final String studentId;
  final String studentName;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  // TAHAP 1 - LOCAL STATE: hanya dipakai oleh halaman detail ini,
  // tidak dibutuhkan screen/widget lain, sehingga cukup memakai setState().
  bool _showDetail = false;

  /// TAHAP 8 (P7): konfirmasi, hapus, lalu tampilkan hasil.
  Future<void> _confirmDelete(Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus course?'),
        content: Text('Course "${course.title}" akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    // Setelah dialog (await), pastikan widget masih terpasang
    if (confirmed != true || !mounted) return;

    final provider = context.read<CourseProvider>();
    final ok = await provider.deleteCourse(course);

    // Setelah await DELETE, periksa mounted lagi sebelum memakai context
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Course berhasil dihapus' : 'Gagal menghapus course: ${provider.saveError}',
        ),
      ),
    );

    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // watch(): halaman detail ikut berubah saat favorite atau data diubah
    final provider = context.watch<CourseProvider>();
    // Ambil data terbaru dari provider (setelah edit dan refresh)
    final course = provider.courses.firstWhere(
      (c) => c.code == widget.course.code,
      orElse: () => widget.course,
    );
    final isFav = provider.isFavorite(course.code);
    final isSaving = provider.isSaving;

    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        actions: [
          // TAHAP 7 (P7): tombol Edit
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit),
            onPressed: isSaving
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CourseFormPage(course: course)),
                    ),
          ),
          // TAHAP 8 (P7): tombol Delete
          IconButton(
            tooltip: 'Hapus',
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: isSaving ? null : () => _confirmDelete(course),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.studentId} - ${widget.studentName}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            const Divider(height: 30),
            Text('Judul: ${course.title}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            // TAHAP 13: status favorit ditampilkan di halaman detail
            Text('Status favorit: ${isFav ? "Favorit" : "Bukan favorit"}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => context.read<CourseProvider>().toggleFavorite(course.code),
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.grey),
              label: Text(isFav ? 'Hapus dari favorit' : 'Tambah ke favorit'),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _showDetail = !_showDetail;
                });
              },
              icon: Icon(_showDetail ? Icons.expand_less : Icons.expand_more),
              label: Text(_showDetail ? 'Sembunyikan detail' : 'Tampilkan detail'),
            ),
            if (_showDetail) ...[
              Text('Kode Mata Kuliah: ${course.code}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Jumlah SKS: ${course.credits}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Status: ${course.status}', style: const TextStyle(fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}