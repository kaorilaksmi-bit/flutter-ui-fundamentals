import 'package:flutter/material.dart';
import '../constants/student_identity.dart';
import 'home_page.dart';
import 'courses_page.dart';
import 'profile_page.dart';

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _selectedIndex = 0;

  // TAHAP 11: data course tidak lagi ditulis di sini.
  // Daftar course, status loading, dan error diambil dari CourseProvider.

  // TAHAP 7: shell tidak lagi memegang/mendengarkan state favorites.
  // Setiap widget yang butuh state membacanya langsung dari Provider.

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        studentId: studentId,
        studentName: studentName,
      ),
      CoursesPage(
        studentId: studentId,
        studentName: studentName,
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