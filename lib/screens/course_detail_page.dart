import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../models/course.dart';

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

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    // watch(): halaman detail ikut berubah saat favorite diubah dari mana pun
    final isFav = context.watch<CourseProvider>().isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
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