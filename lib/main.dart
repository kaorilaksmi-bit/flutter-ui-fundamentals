import 'package:flutter/material.dart';

const String studentName = 'Ni Komang Laksmi Kaori';
const String studentId = '2415051033';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tahap16Page(),
    );
  }
}

class Tahap16Page extends StatefulWidget {
  const Tahap16Page({super.key});

  @override
  State<Tahap16Page> createState() => _Tahap16PageState();
}

class _Tahap16PageState extends State<Tahap16Page> {
  // Variabel untuk Kasus D (Mencegah navigasi ganda)
  bool _isNavigating = false;

  void _safeNavigate() async {
    // Jika sedang proses navigasi, cegah klik berulang
    if (_isNavigating) return;
    
    setState(() => _isNavigating = true);
    
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DummyPage()),
    );
    
    // Kembalikan status setelah kembali dari halaman tujuan
    setState(() => _isNavigating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 16: Debugging Solved')),
      // KASUS C SOLUSI: Menggunakan SingleChildScrollView agar tidak overflow saat keyboard muncul
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
            ),
            const Divider(height: 32),

            // KASUS A SOLUSI: Menggunakan Expanded pada teks panjang di dalam Row
            const Text('Kasus A: RenderFlex Overflow', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.info, color: Colors.blue),
                SizedBox(width: 8),
                Expanded( // Ini solusinya
                  child: Text(
                    'Teks ini sangat panjang dan akan menyebabkan overflow jika tidak dibungkus dengan widget Expanded. Sekarang sudah aman!',
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            // KASUS B SOLUSI: Menambahkan shrinkWrap & NeverScrollableScrollPhysics pada ListView
            const Text('Kasus B: Vertical Viewport Unbounded', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true, // Ini solusinya
              physics: const NeverScrollableScrollPhysics(), // Mematikan scroll internal ListView
              itemCount: 2,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Item ListView $index (Fixed)'),
                  ),
                );
              },
            ),
            const Divider(height: 32),

            // KASUS D SOLUSI: Validasi _isNavigating pada tombol
            const Text('Kasus D: Navigasi Ganda (Double Push)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isNavigating ? null : _safeNavigate,
              child: Text(_isNavigating ? 'Memproses...' : 'Navigasi Aman (Coba tap cepat!)'),
            ),
            const Divider(height: 32),

            // KASUS C (Pemicu Keyboard): TextField ini akan aman dari overflow karena SingleChildScrollView
            const Text('Kasus C: Keyboard Overflow', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Tap di sini untuk buka keyboard',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 100), // Spasi agar halaman bisa di-scroll ke bawah
          ],
        ),
      ),
    );
  }
}

// Halaman dummy untuk mengetes solusi navigasi ganda
class DummyPage extends StatelessWidget {
  const DummyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Tujuan')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const Text('Berhasil pindah halaman dengan aman!'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            )
          ],
        ),
      ),
    );
  }
}