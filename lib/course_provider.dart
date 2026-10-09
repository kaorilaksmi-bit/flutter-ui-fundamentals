   import 'package:flutter/foundation.dart';

   class CourseProvider extends ChangeNotifier {
     CourseProvider({Set<String>? initialFavorites})
         : favorites = {...?initialFavorites};

     final Set<String> favorites;

     bool isFavorite(String id) => favorites.contains(id);

     void toggleFavorite(String id) {
       if (favorites.contains(id)) {
         favorites.remove(id);
       } else {
         favorites.add(id);
       }
       notifyListeners();
     }
   }