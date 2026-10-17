# Course Explorer v2

Aplikasi Flutter Pertemuan 6 - State Management & Mobile Application Architecture.

**Nama:** Ni Komang Laksmi Kaori  
**NIM:** 2415051033

## Arah Dependency

```
Screen / Widget  ->  Provider  ->  Repository  ->  Service / Data Source
```

- UI (screens dan widgets) hanya membaca state dari Provider dan memanggil aksinya.
- UI tidak memanggil `rootBundle` atau `jsonDecode` secara langsung.
- Provider hanya mengenal Repository, tidak mengenal Service dan tidak menyimpan `BuildContext`.
- Service tidak mengandung widget atau kode UI.
- Rangkaian objek (Service -> Repository -> Provider) dibuat sekali di `main()`.

## Tanggung Jawab Tiap Folder

| Folder | Tanggung jawab |
|---|---|
| `lib/main.dart` | Titik masuk aplikasi: merangkai `CourseService`, `CourseRepository`, `CourseProvider` dan menyediakannya lewat `ChangeNotifierProvider`. |
| `lib/constants/` | Konstanta global, yaitu identitas mahasiswa (nama dan NIM). |
| `lib/models/` | Representasi data bertipe (`Course`) dan parsing `fromJson`. |
| `lib/services/` | Detail teknis akses data (membaca JSON asset). Tidak ada kode UI. Dapat diganti dengan API tanpa mengubah screen. |
| `lib/repositories/` | Abstraksi sumber data bagi Provider (`getCourses()`). Provider tidak tahu data berasal dari mana. |
| `lib/providers/` | Penyimpan state dan aksi (`ChangeNotifier`): `courses`, `isLoading`, `error`, dan `favorites`. Tidak memegang `BuildContext`. |
| `lib/screens/` | Halaman utuh: Home, Courses, Favorites, Detail, Profile, dan `ResponsiveShell` (navigasi responsif). |
| `lib/widgets/` | Widget kecil yang dapat dipakai ulang: `CourseCard` dan `SummaryCards`. |
| `assets/data/` | Sumber data JSON (`student_data.json`). |

## Hasil Audit (Tahap 16)

| Pemeriksaan | Hasil |
|---|---|
| Screen/widget memanggil `rootBundle` atau `jsonDecode` | Tidak ada. Hanya `CourseService` yang memakainya. |
| `CourseService` mengandung widget/UI | Tidak ada. Tidak mengimpor `flutter/material`. |
| Provider menyimpan `BuildContext` sebagai state | Tidak ada. |
| Screen/widget mengimpor service atau repository langsung | Tidak ada. |