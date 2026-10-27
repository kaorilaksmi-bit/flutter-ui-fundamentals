class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
  });

  /// Untuk JSON yang memang berbentuk course (code, title, credits, status),
  /// misalnya asset student_data.json. Jika API tidak mengirim status,
  /// nilai default 'planned' dipakai.
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: (json['status'] as String?) ?? 'planned',
    );
  }

  /// TAHAP 3 (Pertemuan 7): pemetaan field untuk JSONPlaceholder /posts.
  /// Endpoint ini tidak punya code, credits, dan status, jadi nilainya
  /// dibuat dari field yang tersedia:
  ///   id -> id, title -> title, code -> 'POST-<id>',
  ///   credits -> 3 (default), status -> 'planned' (default).
  factory Course.fromPostJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    return Course(
      id: id,
      code: 'POST-$id',
      title: json['title'] as String,
      credits: 3,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'title': title,
        'credits': credits,
        'status': status,
      };
}