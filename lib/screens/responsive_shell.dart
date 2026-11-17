import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/student_identity.dart';
import '../providers/course_provider.dart';
import '../services/notification_service.dart';
import 'course_list_page.dart';
import 'favorites_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // PRAKTIK 10: Jalankan inisialisasi lengkap notifikasi
    NotificationService.instance.init();
  }

  Widget _favoriteIcon() {
    return Consumer<CourseProvider>(
      builder: (context, provider, child) => Badge(
        isLabelVisible: provider.favorites.isNotEmpty,
        label: Text('${provider.favorites.length}'),
        child: const Icon(Icons.favorite),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        studentId: studentId,
        studentName: studentName,
      ),
      CourseListPage(
        studentId: studentId,
        studentName: studentName,
      ),
      FavoritesPage(studentId: studentId, studentName: studentName),
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
                  destinations: [
                    const NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                    const NavigationRailDestination(icon: Icon(Icons.school), label: Text('Courses')),
                    NavigationRailDestination(icon: _favoriteIcon(), label: const Text('Favorites')),
                    const NavigationRailDestination(icon: Icon(Icons.person), label: Text('Profile')),
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
            destinations: [
              const NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              const NavigationDestination(icon: Icon(Icons.school), label: 'Courses'),
              NavigationDestination(icon: _favoriteIcon(), label: 'Favorites'),
              const NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}