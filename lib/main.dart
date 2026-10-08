import 'package:flutter/material.dart';

const String studentName = 'Ni Komang Laksmi Kaori';
const String studentId = '2415051033';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ResponsiveShell(),
    );
  }
}

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _courses = [
    {"code": "MOB01", "title": "Git & GitHub", "status": "done", "credits": 2, "isFav": false},
    {"code": "MOB02", "title": "Dart Fundamentals", "status": "done", "credits": 2, "isFav": true},
    {"code": "MOB03", "title": "Flutter UI Fundamentals", "status": "active", "credits": 3, "isFav": false},
    {"code": "WEB01", "title": "Laravel Web Development", "status": "planned", "credits": 3, "isFav": false},
    {"code": "DSG01", "title": "UI/UX Design & Prototyping", "status": "planned", "credits": 2, "isFav": false},
  ];

  // TAHAP 4: ValueNotifier untuk nilai sederhana yang bisa dipantau.
  late final ValueNotifier<int> _favoriteCount =
      ValueNotifier<int>(_courses.where((c) => c['isFav'] == true).length);
  final ValueNotifier<int> _demoCounter = ValueNotifier<int>(0);

  @override
  void dispose() {
    _favoriteCount.dispose();
    _demoCounter.dispose();
    super.dispose();
  }

  // TAHAP 2: state favorites dimiliki parent (ResponsiveShell).
  // Child hanya mengubahnya lewat callback ini.
  void _toggleFavorite(int index) {
    setState(() {
      _courses[index]['isFav'] = !_courses[index]['isFav'];
    });
    // perbarui ValueNotifier agar listener ikut berubah
    _favoriteCount.value = _courses.where((c) => c['isFav'] == true).length;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        studentId: studentId,
        studentName: studentName,
        courses: _courses, // data dikirim lewat constructor (child 1)
        onToggleFavorite: _toggleFavorite, // callback child -> parent
        favoriteCount: _favoriteCount,
        demoCounter: _demoCounter,
      ),
      CoursesPage(
        courses: _courses,
        studentId: studentId,
        studentName: studentName,
        onToggleFavorite: _toggleFavorite, // data + callback (child 2)
      ),
      ProfilePage(studentId: studentId, studentName: studentName),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 840) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) => setState(() => _selectedIndex = index),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                    NavigationRailDestination(icon: Icon(Icons.school), label: Text('Courses')),
                    NavigationRailDestination(icon: Icon(Icons.person), label: Text('Profile')),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: pages[_selectedIndex]),
              ],
            ),
          );
        }

        return Scaffold(
          body: pages[_selectedIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.school), label: 'Courses'),
              NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final String studentId;
  final String studentName;
  final List<Map<String, dynamic>> courses;
  final void Function(int index) onToggleFavorite;
  final ValueNotifier<int> favoriteCount;
  final ValueNotifier<int> demoCounter;

  const HomePage({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.courses,
    required this.onToggleFavorite,
    required this.favoriteCount,
    required this.demoCounter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Explorer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selamat Datang,', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('Course Explorer Dashboard', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text('$studentId - $studentName', style: const TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Menu Utama', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.school, color: Colors.blue),
                title: const Text('Jelajahi Daftar Course'),
                subtitle: const Text('Lihat modul pembelajaran mobile programming'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Eksperimen ValueNotifier', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    // Hanya widget ini yang rebuild saat favoriteCount berubah
                    ValueListenableBuilder<int>(
                      valueListenable: favoriteCount,
                      builder: (context, value, child) => Text('Jumlah favorite: $value'),
                    ),
                    const SizedBox(height: 8),
                    // Counter demo: berubah tanpa setState() pada parent
                    ValueListenableBuilder<int>(
                      valueListenable: demoCounter,
                      builder: (context, value, child) {
                        debugPrint('ValueListenableBuilder rebuild: $value');
                        return Row(
                          children: [
                            Text('Counter: $value'),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () => demoCounter.value++,
                              child: const Text('Tambah'),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Course Favorit (${courses.where((c) => c['isFav'] == true).length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (courses.every((c) => c['isFav'] != true))
              const Text('Belum ada course favorit.'),
            for (int i = 0; i < courses.length; i++)
              if (courses[i]['isFav'] == true)
                Card(
                  child: ListTile(
                    title: Text(courses[i]['title']),
                    subtitle: Text(courses[i]['code']),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => onToggleFavorite(i),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class CoursesPage extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  final String studentId;
  final String studentName;
  final void Function(int index) onToggleFavorite;

  const CoursesPage({super.key, required this.courses, required this.studentId, required this.studentName, required this.onToggleFavorite});

  int _getCrossAxisCount(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Courses')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$studentId - $studentName', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(constraints.maxWidth),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      // TAHAP 3: CourseCard tidak menyimpan state favorite.
                      // Ia hanya menerima nilai (isFavorite) dan mengirim aksi (callback).
                      return CourseCard(
                        course: course,
                        isFavorite: course['isFav'] == true,
                        onFavoriteChanged: () => onToggleFavorite(index),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailPage(
                                course: course,
                                studentId: studentId,
                                studentName: studentName,
                                onFavoriteChanged: () => onToggleFavorite(index),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.onFavoriteChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(course['code'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onFavoriteChanged,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                course['title'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text('Status: ${course['status']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseDetailPage extends StatefulWidget {
  final Map<String, dynamic> course;
  final String studentId;
  final String studentName;
  final VoidCallback onFavoriteChanged;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.studentId,
    required this.studentName,
    required this.onFavoriteChanged,
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
    // Dibaca langsung dari sumber yang sama (_courses di parent), bukan salinan.
    final isFav = course['isFav'] == true;

    return Scaffold(
      appBar: AppBar(title: Text(course['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.studentId} - ${widget.studentName}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            const Divider(height: 30),
            Text('Judul: ${course['title']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                widget.onFavoriteChanged(); // ubah state di parent
                setState(() {}); // route detail berada di luar shell, jadi perlu rebuild sendiri
              },
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
              Text('Kode Mata Kuliah: ${course['code']}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Jumlah SKS: ${course['credits']}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Status: ${course['status']}', style: const TextStyle(fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final String studentId;
  final String studentName;

  const ProfilePage({super.key, required this.studentId, required this.studentName});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _nimController;
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.studentName);
    _nimController = TextEditingController(text: widget.studentId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Kirim feedback sekarang?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Kirim')),
          ],
        ),
      );

      if (confirm == true) {
        setState(() => _isLoading = true);
        await Future.delayed(const Duration(seconds: 2));
        setState(() => _isLoading = false);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Feedback berhasil dikirim!'),
              backgroundColor: Colors.green,
            ),
          );
          _commentController.clear();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil & Feedback')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 30)),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.studentName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(widget.studentId, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const Divider(height: 30),
              const Text('Form Feedback Aplikasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()),
                validator: (value) => value == null || value.trim().isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(labelText: 'NIM', border: OutlineInputBorder()),
                validator: (value) => value == null || value.trim().isEmpty ? 'NIM wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(labelText: 'Komentar / Saran', border: OutlineInputBorder(), hintText: 'Minimal 5 karakter'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Komentar wajib diisi';
                  if (value.trim().length < 5) return 'Komentar minimal 5 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitFeedback,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Kirim Feedback'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}