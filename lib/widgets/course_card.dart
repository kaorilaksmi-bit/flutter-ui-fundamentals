import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
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
                  Text(course.code, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
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
                course.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text('Status: ${course.status}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}