import 'package:flutter/foundation.dart';

/// TAHAP 5: state favorites dipisah dari widget ke class ChangeNotifier.
/// Class ini tidak mengenal widget atau BuildContext.
class CourseState extends ChangeNotifier {
  CourseState({Set<String>? initialFavorites})
      : favorites = {...?initialFavorites};

  /// Kumpulan kode course yang menjadi favorit.
  final Set<String> favorites;

  bool isFavorite(String id) => favorites.contains(id);

  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    // Wajib dipanggil setelah state berubah agar listener (UI) diberi tahu.
    notifyListeners();
  }
}