# Course Data Manager

Aplikasi Flutter untuk mengelola data mata kuliah (course) dengan operasi CRUD
(Create, Read, Update, Delete) yang terhubung ke backend dan database.
Aplikasi ini merupakan pengembangan **Course Explorer v2** (Pertemuan 5-6) pada
Pertemuan 7: RESTful API, Backend Services & Database Integration.

**Nama:** Ni Komang Laksmi Kaori  
**NIM:** 2415051033

## Fitur

- Menampilkan daftar course dari backend/database (loading, empty, error dengan retry).
- Menambah course melalui form dengan validasi (kode, judul, SKS, status).
- Mengubah course dari halaman detail (kode bersifat read-only).
- Menghapus course dengan dialog konfirmasi.
- Favorites memakai `code` sebagai kunci dan konsisten di beberapa screen.
- Responsive navigation (NavigationBar / NavigationRail).
- Umpan balik operasi berhasil atau gagal melalui SnackBar.

## Backend yang Digunakan

| Backend | Peran |
|---|---|
| **Supabase (PostgreSQL)** | Sumber data aktif aplikasi final (`CourseSupabaseService`), tabel `courses`, dilindungi RLS. |
| **JSONPlaceholder (REST API dummy)** | Dipakai pada Tahap 1-9 untuk belajar GET/POST/PUT/DELETE (`CourseApiService`). Operasi tulis hanya simulasi. |

## Arsitektur Singkat

```
Screen / Widget  ->  CourseProvider  ->  CourseRepository  ->  CourseDataSource (kontrak)
                                                                 |-- CourseSupabaseService (aktif)
                                                                 |-- CourseApiService (REST, cadangan)
```

- Screen dan provider tidak memuat package HTTP maupun Supabase.
- Sumber data aktif dipilih hanya di `lib/main.dart`. Satu baris berikut yang diubah untuk berpindah sumber:

```dart
final CourseDataSource dataSource = CourseSupabaseService();
// untuk REST: CourseApiService('https://jsonplaceholder.typicode.com')
```

## Struktur Folder

```
lib/
├── main.dart
├── config/            konfigurasi Supabase (URL dan anon key)
├── constants/         identitas mahasiswa
├── models/            Course (fromJson / toJson)
├── services/          CourseDataSource, CourseApiService, CourseSupabaseService
├── repositories/      CourseRepository
├── providers/         CourseProvider (state: courses, loading, error, favorites)
├── screens/           responsive_shell, home, course_list, course_detail, course_form, favorites, profile
└── widgets/           course_card, error_view, summary_cards
supabase/
└── courses.sql        skrip pembuatan tabel, data awal, dan policy RLS
```

## Cara Menjalankan

1. Pastikan Flutter terpasang, lalu ambil dependency:
   ```
   flutter pub get
   ```
2. Siapkan Supabase:
   - Buat project di [supabase.com](https://supabase.com).
   - Buka SQL Editor, lalu jalankan isi `supabase/courses.sql`.
   - Isi `lib/config/supabase_config.dart` dengan **Project URL** dan **anon/publishable key**.
   - Jangan pernah memakai service role key atau secret key pada aplikasi.
3. Jalankan aplikasi:
   ```
   flutter run
   ```
   Pada Windows, aktifkan **Developer Mode** agar plugin dapat dibangun.

## Catatan Keamanan

- Hanya anon/publishable key yang dipakai di aplikasi. Keamanan data dijaga oleh
  Row Level Security (RLS) di Supabase.
- Policy pada `courses.sql` sangat permisif dan **hanya untuk praktikum**, bukan pola produksi.
- Validasi pada UI bukan pengganti validasi dan otorisasi di backend.