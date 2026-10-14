import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

class FavoriteSummaryCard extends StatelessWidget {
  const FavoriteSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    // watch(): widget ini rebuild setiap favorites berubah
    final provider = context.watch<CourseProvider>();
    debugPrint('FavoriteSummaryCard rebuild');
    return Card(
      child: ListTile(
        leading: const Icon(Icons.favorite, color: Colors.red),
        title: Text('Jumlah favorite: ${provider.favorites.length}'),
      ),
    );
  }
}