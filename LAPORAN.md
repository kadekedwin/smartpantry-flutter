# LAPORAN PENGEMBANGAN APLIKASI SMART PANTRY

**Aplikasi Manajemen Bahan Dapur Berbasis Mobile (Flutter)**

---

## DAFTAR ISI

- BAB I: PENDAHULUAN
- BAB II: LANDASAN TEORI
- BAB III: ANALISIS DAN PERANCANGAN SISTEM
- BAB IV: IMPLEMENTASI DAN PENGUJIAN
- BAB V: PENUTUP

---

# BAB I
# PENDAHULUAN

## 1.1 Latar Belakang

Aktivitas rumah tangga sehari-hari, khususnya di dapur, tidak dapat dilepaskan dari pengelolaan bahan makanan. Banyak keluarga di Indonesia mengalami permasalahan klasik dalam manajemen bahan dapur, antara lain:

1. **Bahan makanan terbuang** karena tidak diketahui kapan tanggal kedaluwarsanya, sehingga baru diketahui ketika sudah rusak atau berjamur.
2. **Kesulitan mengontrol stok** bahan yang tersimpan di kulkas, freezer, maupun rak dapur, sehingga sering terjadi pembelian ganda atau kehabisan bahan penting saat dibutuhkan.
3. **Daftar belanja yang tidak terorganisir**, biasanya masih ditulis di kertas atau catatan yang mudah hilang.
4. **Tidak adanya pengingat otomatis** ketika bahan mendekati masa kedaluwarsa atau stok menipis.

Menurut data Food and Agriculture Organization (FAO), Indonesia merupakan salah satu negara penyumbang *food waste* terbesar di Asia. Salah satu penyumbang terbesarnya adalah rumah tangga yang tidak memiliki sistem pengelolaan bahan dapur yang baik. Berdasarkan hal tersebut, dibutuhkan sebuah solusi digital yang dapat membantu masyarakat, khususnya ibu rumah tangga atau siapa pun yang mengelola dapur, untuk mencatat, memantau, dan mendapatkan pengingat terkait bahan dapur mereka.

**Smart Pantry** merupakan aplikasi *mobile* berbasis **Flutter** yang dirancang untuk menjawab kebutuhan tersebut. Aplikasi ini berperan sebagai *client* yang berkomunikasi dengan sebuah REST API sebagai penyimpan data terpusat. Fokus pengembangan pada laporan ini adalah **sisi aplikasi mobile (Flutter)**, sedangkan API dibahas sebatas kontrak endpoint yang digunakan oleh aplikasi.

## 1.2 Rumusan Masalah

Berdasarkan latar belakang di atas, rumusan masalah dalam pengembangan aplikasi Smart Pantry adalah sebagai berikut:

1. Bagaimana merancang sebuah aplikasi *mobile* berbasis Flutter yang mampu mencatat bahan dapur berdasarkan kategori penyimpanan (kulkas, freezer, dan rak dapur)?
2. Bagaimana mengintegrasikan aplikasi Flutter dengan REST API sebagai sumber data utama?
3. Bagaimana menyajikan informasi status kedaluwarsa bahan dapur secara visual (*color-coded*) sehingga mudah dipahami pengguna?
4. Bagaimana membangun alur navigasi antar layar (onboarding, autentikasi, dan dashboard) yang intuitif dan responsif?

## 1.3 Tujuan

Tujuan dari pengembangan aplikasi Smart Pantry adalah:

1. Membangun aplikasi *mobile* Smart Pantry menggunakan Flutter yang dapat digunakan untuk mencatat, melihat, dan mengelola bahan dapur pengguna.
2. Mengimplementasikan lapisan *service* yang mengkonsumsi REST API sebagai sumber data.
3. Menyajikan antarmuka pengguna yang intuitif dan berbahasa Indonesia agar mudah digunakan pengguna dalam negeri.
4. Menerapkan mekanisme autentikasi berbasis JWT yang tersimpan di perangkat pengguna sehingga sesi pengguna tetap terjaga.

## 1.4 Manfaat

**Manfaat teoritis:**
- Menjadi rujukan pengembangan aplikasi *mobile* Flutter yang terintegrasi dengan REST API.
- Menambah literatur mengenai penerapan arsitektur berlapis (UI–Service–Model) pada aplikasi Flutter.

**Manfaat praktis:**
- Membantu pengguna mengurangi *food waste* karena adanya pengingat kedaluwarsa.
- Mempermudah pengguna dalam menyusun dan mengelola daftar belanja.
- Memberikan gambaran *real-time* terkait jumlah stok di setiap kategori penyimpanan.

## 1.5 Batasan Masalah

Agar pengembangan lebih terfokus, dilakukan pembatasan sebagai berikut:

1. Aplikasi dibangun untuk platform *mobile* (Android dan iOS) menggunakan Flutter, dengan pengujian utama pada Android.
2. Antarmuka dan seluruh teks aplikasi menggunakan Bahasa Indonesia.
3. Pembahasan API dibatasi pada daftar endpoint yang digunakan oleh aplikasi (tanpa membahas implementasi internal server).
4. Autentikasi menggunakan JWT yang disimpan pada `shared_preferences` di sisi klien.
5. Halaman *Home* masih menampilkan konten statis; hanya digunakan sebagai halaman ringkasan visual.
6. Fitur rekomendasi menu (`cooking notification`) belum diimplementasikan pada versi ini.

## 1.6 Sistematika Penulisan

Laporan ini disusun sebagai berikut:

- **BAB I: PENDAHULUAN** — memuat latar belakang, rumusan masalah, tujuan, manfaat, batasan, dan sistematika penulisan.
- **BAB II: LANDASAN TEORI** — memuat teori dan referensi teknologi yang digunakan.
- **BAB III: ANALISIS DAN PERANCANGAN SISTEM** — memuat analisis kebutuhan dan perancangan sistem Flutter.
- **BAB IV: IMPLEMENTASI DAN PENGUJIAN** — memuat detail implementasi Flutter dan pengujian.
- **BAB V: PENUTUP** — memuat kesimpulan dan saran.

---

# BAB II
# LANDASAN TEORI

## 2.1 Smart Pantry / Pantry Management System

*Pantry management* adalah kegiatan mengelola stok bahan makanan yang disimpan di rumah tangga. Sistem digital *pantry management* umumnya memuat fitur pencatatan bahan, monitoring stok, pengingat kedaluwarsa, serta daftar belanja. Dengan digitalisasi, potensi lupa dan potensi *food waste* dapat ditekan secara signifikan.

## 2.2 Flutter

**Flutter** adalah *framework* UI *open-source* yang dikembangkan oleh Google untuk membangun aplikasi *cross-platform* (Android, iOS, Web, Desktop) dari satu basis kode. Flutter menggunakan bahasa pemrograman **Dart** dan mesin *rendering* Skia. Setiap elemen UI di Flutter adalah *widget* yang dapat berupa `StatelessWidget` maupun `StatefulWidget`.

Kelebihan Flutter:
- **Hot Reload** — perubahan kode langsung terlihat tanpa *restart*.
- **Widget-based** — UI dibangun secara deklaratif.
- **Cross-platform** — satu kode dapat berjalan di banyak platform.
- **Native performance** — dikompilasi langsung ke kode ARM.

Aplikasi Smart Pantry menggunakan Flutter SDK `^3.11.0`.

## 2.3 Dart

**Dart** adalah bahasa pemrograman berbasis *object-oriented* dengan sintaks mirip C-family (Java/JavaScript). Dart mendukung *null safety*, *async/await*, dan *strong typing*, yang sangat cocok untuk pengembangan aplikasi Flutter.

## 2.4 Widget dan State Management

Di Flutter, seluruh antarmuka pengguna disusun dari *widget*.

- **StatelessWidget** — widget yang tidak memiliki state internal.
- **StatefulWidget** — widget yang memiliki state internal (memakai `State<T>` dan `setState`).

Smart Pantry menggunakan pendekatan *plain* `setState` dan `Future` (tanpa Provider, Riverpod, atau Bloc) karena kompleksitas state aplikasi masih tergolong sederhana.

## 2.5 REST API dan JSON

**REST (Representational State Transfer)** adalah gaya arsitektur untuk perancangan *web service* yang memanfaatkan protokol HTTP secara langsung. Setiap *resource* diakses melalui URL unik menggunakan HTTP method (GET, POST, PATCH, DELETE, dsb).

**JSON (JavaScript Object Notation)** adalah format pertukaran data ringan yang digunakan Smart Pantry sebagai *body* request maupun *body* response.

## 2.6 JWT (JSON Web Token)

**JWT** adalah standar token berbasis JSON (RFC 7519) yang digunakan untuk otentikasi. Pada Smart Pantry, JWT diterima setelah pengguna berhasil *login* atau *register*, kemudian disimpan pada `shared_preferences` dan disertakan dalam setiap request melalui header `Authorization: Bearer <token>`.

## 2.7 Pustaka Pendukung di Flutter

| Pustaka | Versi | Fungsi |
|---------|-------|--------|
| `dio` | ^5.7.0 | HTTP *client* untuk pemanggilan REST API. Mendukung `FormData` untuk *multipart upload*. |
| `flutter_dotenv` | ^5.2.1 | Membaca file `.env` untuk konfigurasi (base URL API). |
| `shared_preferences` | ^2.3.2 | Menyimpan JWT secara persisten pada perangkat. |
| `image_picker` | ^1.1.2 | Memilih gambar dari galeri atau kamera untuk *upload* bahan. |
| `flutter_svg` | ^2.0.10+1 | *Rendering* ikon SVG (misalnya tombol Apple *sign-in*). |
| `cupertino_icons` | ^1.0.8 | Kumpulan ikon bergaya iOS. |

## 2.8 Material Design 3

Aplikasi Smart Pantry menggunakan **Material 3** yang diaktifkan via `useMaterial3: true` pada `ThemeData`. `ColorScheme.fromSeed` digunakan untuk menghasilkan palet warna berdasarkan warna utama hijau `#059669`.

## 2.9 Arsitektur Berlapis pada Aplikasi Flutter

Smart Pantry mengadopsi arsitektur tiga lapis di sisi klien:

1. **Presentation Layer** — `screens/` (widget dan UI).
2. **Service Layer** — `services/` (pemanggilan REST API, penyimpanan token).
3. **Data Layer** — `data/models/` (model kelas hasil parsing JSON).

Pemisahan ini membuat kode lebih mudah dirawat dan diuji.

---

# BAB III
# ANALISIS DAN PERANCANGAN SISTEM

## 3.1 Analisis Kebutuhan

### 3.1.1 Kebutuhan Fungsional

| Kode | Deskripsi |
|------|-----------|
| KF-01 | Pengguna dapat mendaftar akun baru dengan nama, email, dan *password*. |
| KF-02 | Pengguna dapat masuk (*login*) menggunakan email dan *password*. |
| KF-03 | Pengguna dapat keluar (*logout*) dari akunnya. |
| KF-04 | Pengguna dapat melihat profil dirinya (nama, email, avatar). |
| KF-05 | Pengguna dapat melihat daftar bahan dapur pada tiga kategori: kulkas, freezer, dan rak dapur. |
| KF-06 | Pengguna dapat menambahkan bahan dapur beserta gambar, stok, satuan, tanggal kedaluwarsa, dan kategori. |
| KF-07 | Sistem menampilkan indikator warna untuk status kedaluwarsa (merah ≤ 2 hari, kuning ≤ 5 hari, hijau > 5 hari). |
| KF-08 | Pengguna dapat melihat daftar belanja. |
| KF-09 | Pengguna dapat menambahkan item ke daftar belanja. |
| KF-10 | Pengguna dapat menandai item belanja sudah dibeli (*toggle*). |
| KF-11 | Pengguna dapat melihat daftar notifikasi yang dikirim oleh server. |
| KF-12 | Aplikasi menjaga sesi *login* selama token JWT masih tersimpan pada perangkat. |

### 3.1.2 Kebutuhan Non-Fungsional

| Kode | Deskripsi |
|------|-----------|
| KNF-01 | Antarmuka menggunakan Bahasa Indonesia. |
| KNF-02 | Autentikasi menggunakan JWT yang disimpan pada `shared_preferences`. |
| KNF-03 | Response API konsisten dengan format `{ data, message }`. |
| KNF-04 | Ukuran maksimal gambar *upload* adalah 5 MB. |
| KNF-05 | Format tanggal kedaluwarsa mengikuti ISO 8601 (`YYYY-MM-DD`). |
| KNF-06 | UI menampilkan indikator *loading* dan tombol *retry* saat terjadi kegagalan jaringan. |

### 3.1.3 Aktor Sistem

- **Pengguna (User)** — pengguna akhir aplikasi *mobile* Flutter. Dapat melakukan seluruh aktivitas manajemen dapur pribadi melalui aplikasi.

## 3.2 Perancangan Arsitektur Aplikasi Flutter

Aplikasi Flutter dibangun dengan arsitektur berlapis sebagai berikut:

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│   screens/  (Widgets, UI, Navigation)   │
└───────────────────┬─────────────────────┘
                    │
┌───────────────────▼─────────────────────┐
│             Service Layer               │
│   services/  (ApiClient + domain svc)   │
└───────────────────┬─────────────────────┘
                    │
┌───────────────────▼─────────────────────┐
│               Data Layer                │
│   data/models/  (fromJson factories)    │
└───────────────────┬─────────────────────┘
                    │ HTTP + JSON (Bearer JWT)
                    ▼
              [ REST API Server ]
```

**Alur singkat:**
1. Pengguna berinteraksi dengan widget pada layar.
2. Widget memanggil *service class* (mis. `InventoryService`).
3. *Service class* meneruskan request ke `ApiClient` (berbasis `dio`).
4. `ApiClient` mengirim HTTP request dengan header JWT ke REST API.
5. Response JSON di-*unwrap* dari envelope `{ data, message }`, di-*parse* menjadi *model class*, lalu ditampilkan pada widget.

## 3.3 Kontrak REST API (Endpoint yang Digunakan)

Aplikasi Flutter mengkonsumsi API dengan *base URL* `http://<host>:3000/v1` (dikonfigurasi via `.env`). Berikut daftar endpoint yang dipakai:

| Method | Endpoint | Auth | Dipakai oleh |
|--------|----------|------|--------------|
| POST | `/auth/register` | – | `RegisterScreen` |
| POST | `/auth/login` | – | `LoginScreen` |
| POST | `/auth/logout` | ✓ | `ProfileTab` |
| GET | `/profile` | ✓ | `ProfileTab` |
| GET | `/inventory` (opsional `?category=`) | ✓ | `InventoryTab` |
| POST | `/inventory` (multipart) | ✓ | `AddTab` — *Input Langsung* |
| GET | `/shopping` | ✓ | `AddTab` — *Daftar Belanja* |
| POST | `/shopping` | ✓ | `AddTab` — *Daftar Belanja* |
| PATCH | `/shopping/:id/toggle` | ✓ | `AddTab` — *Daftar Belanja* |
| GET | `/notifications` | ✓ | `NotificationTab` |

Seluruh endpoint mengembalikan JSON dengan format:

```json
{ "data": ..., "message": "..." }
```

Aplikasi Flutter hanya perlu mengetahui kontrak endpoint di atas; detail implementasi *server* berada di luar cakupan laporan ini.

## 3.4 Perancangan Model Data (Data Layer)

Empat *model class* dibuat pada `lib/data/models/` untuk merepresentasikan payload API:

### 3.4.1 `User`

Field: `id`, `name`, `email`, `avatarUrl`. Dibaca dari response `/auth/*` dan `/profile`.

### 3.4.2 `InventoryItem`

Field: `id`, `name`, `image` (URL), `stock`, `unit`, `expiredAt` (`DateTime`), `category` (`kulkas` | `freezer` | `rak_dapur`).

Memiliki *getter* `expiredInfo` yang menghitung selisih hari dan mengembalikan label relatif berbahasa Indonesia:
- `< 0` hari → `"Kedaluwarsa"`
- `= 0` hari → `"Hari Ini"`
- `< 30` hari → `"N Hari Lagi"`
- `≥ 30` hari → `"N Bulan Lagi"`

### 3.4.3 `ShoppingItem`

Field: `id`, `name`, `quantity`, `unit`, `isBought`.

### 3.4.4 `NotificationItem`

Field: `id`, `title`, `description`, `type` (enum `NotificationType`: `cooking`, `stock`, `warning`, `expired`), `createdAt`.

Memiliki *getter*:
- `group` — mengelompokkan berdasarkan waktu (`HARI INI`, `KEMARIN`, `7 HARI LALU`, `30 HARI LALU`, `LEBIH LAMA`).
- `time` — label waktu relatif (`"X menit yang lalu"`).

## 3.5 Perancangan Service Layer

Setiap domain memiliki *service class* berisi metode statis yang mem-*wrap* pemanggilan `ApiClient`:

| Service | Metode |
|---------|--------|
| `ApiClient` | `get`, `post`, `postForm`, `patch` (mengelola JWT + *unwrap* envelope) |
| `TokenStorage` | `save`, `read`, `clear` |
| `AuthService` | `register`, `login`, `logout` |
| `ProfileService` | `get` |
| `InventoryService` | `list`, `create`, `revision` (`ValueNotifier` untuk sinkronisasi antar-tab) |
| `ShoppingService` | `list`, `create`, `toggle` |
| `NotificationService` | `list` |

## 3.6 Perancangan Antarmuka (UI Flow)

### 3.6.1 Alur Navigasi

```
[OnboardingScreen] → [LoginScreen] ↔ [RegisterScreen]
        │
        ▼
[DashboardScreen] (IndexedStack — 5 Tab)
   ├── [HomeTab]
   ├── [InventoryTab]
   ├── [AddTab]
   ├── [NotificationTab]
   └── [ProfileTab]
```

Navigasi menggunakan `Navigator.push` dan `Navigator.pushReplacement` tanpa *named route*. Pada `main()`, aplikasi memeriksa keberadaan token; jika ada langsung ke `DashboardScreen`, jika tidak ada ke `OnboardingScreen`.

### 3.6.2 Perancangan Layar

**OnboardingScreen** — memperkenalkan aplikasi kepada pengguna baru.

**LoginScreen** — form email + password dengan tombol menuju halaman registrasi.

**RegisterScreen** — form nama, email, password.

**DashboardScreen** — memakai `IndexedStack` untuk mempertahankan *state* setiap tab saat berpindah.

**HomeTab** — carousel promo, aksi cepat, dan bagian bahan yang akan kedaluwarsa (data statis).

**InventoryTab** — menampilkan `GridView` bahan per kategori dengan filter *pill tabs* (Kulkas, Freezer, Rak Dapur). Header menampilkan jumlah item per kategori. Indikator warna:
- Merah `#EF4444` bila ≤ 2 hari lagi
- Kuning `#F59E0B` bila ≤ 5 hari lagi
- Hijau `#0F9F68` bila > 5 hari

**AddTab** — memiliki dua tab internal:
- *Daftar Belanja* — CRUD ringan dengan *checkbox toggle*.
- *Input Langsung* — form penambahan bahan dapur dengan pemilih gambar (`image_picker`).

**NotificationTab** — daftar notifikasi yang dikelompokkan berdasarkan waktu.

**ProfileTab** — informasi profil, tombol edit, menu, dan tombol *logout*.

### 3.6.3 Tema dan Warna

Tidak ada berkas tema terpusat; warna utama dideklarasikan sebagai konstanta lokal pada tiap layar.

| Peran | Kode Hex |
|-------|----------|
| Primary green | `#059669` / `#0F9F68` |
| Foreground | `#111827` / `#1F2937` |
| Muted text | `#6B7280` / `#9CA3AF` |
| Danger / expired | `#EF4444` |
| Background | `#F9FAFB` |

---

# BAB IV
# IMPLEMENTASI DAN PENGUJIAN

## 4.1 Lingkungan Pengembangan

| Komponen | Versi/Konfigurasi |
|----------|-------------------|
| Sistem Operasi | macOS Darwin 25.5.0 |
| Flutter SDK | ^3.11.0 |
| Dart SDK | Bawaan Flutter |
| Editor | Visual Studio Code / Android Studio |
| Emulator | Android Emulator / iOS Simulator |

## 4.2 Struktur Direktori Aplikasi

```
smartpantry/
├── lib/
│   ├── main.dart
│   ├── config/
│   │   └── env.dart
│   ├── data/
│   │   └── models/
│   │       ├── inventory_item.dart
│   │       ├── notification_item.dart
│   │       ├── shopping_item.dart
│   │       └── user.dart
│   ├── services/
│   │   ├── api_client.dart
│   │   ├── auth_service.dart
│   │   ├── inventory_service.dart
│   │   ├── notification_service.dart
│   │   ├── profile_service.dart
│   │   ├── shopping_service.dart
│   │   └── token_storage.dart
│   └── screens/
│       ├── onboarding/
│       │   └── onboarding_screen.dart
│       ├── auth/
│       │   ├── login_screen.dart
│       │   └── register_screen.dart
│       └── dashboard/
│           ├── dashboard_screen.dart
│           ├── tabs/
│           │   ├── home_tab.dart
│           │   ├── inventory_tab.dart
│           │   ├── add_tab.dart
│           │   ├── notification_tab.dart
│           │   ├── profile_tab.dart
│           │   └── widgets/
│           └── widgets/
│               ├── header.dart
│               ├── search.dart
│               └── bottom_nav_bar.dart
├── assets/
├── .env
└── pubspec.yaml
```

## 4.3 Implementasi Titik Masuk Aplikasi

Berkas `main.dart` memuat konfigurasi awal aplikasi:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final token = await TokenStorage.read();
  runApp(SmartPantryApp(loggedIn: token != null && token.isNotEmpty));
}
```

Aplikasi membaca `.env`, memeriksa keberadaan JWT, lalu mengarahkan pengguna ke `DashboardScreen` atau `OnboardingScreen`. `MaterialApp` menggunakan `ColorScheme.fromSeed` dengan warna utama hijau `#059669` dan Material 3.

## 4.4 Implementasi Konfigurasi Environment

`lib/config/env.dart`:

```dart
class Env {
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/v1';
}
```

Berkas `.env` menyimpan `API_BASE_URL`. Untuk *emulator* Android digunakan `http://10.0.2.2:3000/v1` menggantikan `localhost`.

## 4.5 Implementasi Service Layer

### 4.5.1 `ApiClient`

`ApiClient` merupakan *thin wrapper* di atas `dio`. Fitur utamanya:
- Membuat satu *instance* `Dio` dengan `baseUrl` dari `Env`.
- *Interceptor* otomatis menambahkan header `Authorization: Bearer <token>` bila request memerlukan autentikasi (opsi `auth = true`).
- *Log interceptor* aktif hanya pada `kDebugMode`.
- Menangani seluruh HTTP status via `validateStatus: (_) => true` sehingga tidak melempar exception mentah.
- *Unwrap* envelope `{ data, message }` sehingga *service class* menerima `data` secara langsung.
- Non-2xx response dikonversi menjadi `ApiException` berisi status dan pesan.
- Menyediakan *helper*: `get`, `post`, `postForm` (multipart), dan `patch`.

### 4.5.2 `TokenStorage`

Menggunakan `shared_preferences`:

```dart
class TokenStorage {
  static const _tokenKey = 'auth_token';
  static Future<void> save(String token) async { ... }
  static Future<String?> read() async { ... }
  static Future<void> clear() async { ... }
}
```

### 4.5.3 `AuthService`

Menangani `register`, `login`, dan `logout`. Setelah `register` atau `login` berhasil, token langsung disimpan via `TokenStorage.save`. Pada `logout`, token dihapus dari perangkat meskipun request `/auth/logout` gagal (`try/finally`).

### 4.5.4 `InventoryService`

- `list({String? category})` memanggil `GET /inventory` dan memetakan tiap elemen ke `InventoryItem.fromJson`.
- `create(...)` menggunakan `FormData` `dio` untuk *multipart upload* yang berisi field teks + `MultipartFile.fromFile` untuk gambar.
- Memiliki `static final ValueNotifier<int> revision` yang di-*increment* setiap kali item baru berhasil ditambahkan. `InventoryTab` mendengarkan `revision` sehingga secara otomatis me-*refresh* daftar barang tanpa perlu diperbarui manual saat pengguna berpindah dari `AddTab`.

### 4.5.5 `ShoppingService` dan `NotificationService`

`ShoppingService` menyediakan `list`, `create`, dan `toggle`. `NotificationService` hanya menyediakan `list`. Keduanya memakai pola yang sama: memanggil `ApiClient` dan memetakan hasil ke *model*.

## 4.6 Implementasi UI dan Navigasi

### 4.6.1 `DashboardScreen`

Menggunakan `IndexedStack` untuk mempertahankan *state* seluruh tab:

```dart
IndexedStack(
  index: _currentIndex,
  children: const [HomeTab(), InventoryTab(), AddTab(),
                   NotificationTab(), ProfileTab()],
)
```

`AppBottomNavBar` menerima `currentIndex` dan `onTap` untuk berpindah tab.

### 4.6.2 `LoginScreen` dan `RegisterScreen`

Menggunakan `Form` + `GlobalKey<FormState>` dengan validasi *inline*. Ketika submit:
1. Menampilkan *loading state* (`_loading = true`).
2. Memanggil `AuthService.login`/`register`.
3. Bila sukses → `Navigator.pushReplacement` ke `DashboardScreen`.
4. Bila `ApiException` → menampilkan `SnackBar` merah dengan pesan error.
5. Bila error lain → pesan generik `"Tidak dapat terhubung ke server"`.

### 4.6.3 `InventoryTab`

Layar paling representatif yang menunjukkan pola konsumsi API dengan `FutureBuilder`. Alur:
1. `initState` — memulai `Future` dan memasang *listener* `InventoryService.revision`.
2. `dispose` — melepas *listener*.
3. `FutureBuilder<List<InventoryItem>>` — menampilkan:
   - `CircularProgressIndicator` saat *loading*.
   - Pesan error + tombol *"Coba lagi"* saat `ApiException`.
   - `GridView` 2 kolom bila data tersedia.
4. `RefreshIndicator` — memungkinkan *pull-to-refresh*.
5. `_getExpiryColor` — memilih warna sesuai selisih hari:

```dart
if (days <= 2) return const Color(0xFFEF4444); // merah
if (days <= 5) return const Color(0xFFF59E0B); // kuning
return const Color(0xFF0F9F68);                // hijau
```

Header memakai `HeaderInventoryView` yang menampilkan jumlah item per kategori.

### 4.6.4 `AddTab`

Menggunakan `DefaultTabController(length: 2)` dengan `TabBar` + `TabBarView` untuk dua sub-tab:
- *Daftar Belanja* — `ListView` yang menampilkan `ShoppingListItem` beserta *checkbox toggle* yang memanggil `ShoppingService.toggle`.
- *Input Langsung* — form dengan `image_picker` untuk memilih foto (galeri/kamera), field `name`, `stock`, `unit`, `expired_at` (`showDatePicker`), dan `category` (dropdown). Ketika submit, memanggil `InventoryService.create` yang men-*trigger* `revision++` untuk sinkronisasi ke `InventoryTab`.

### 4.6.5 `NotificationTab`

Menggunakan `FutureBuilder` untuk memuat data, lalu mengelompokkan notifikasi dengan *getter* `group` dari `NotificationItem`. Tampilan berupa `ListView` dengan `NotificationCard` yang memiliki ikon berbeda per `NotificationType`.

### 4.6.6 `ProfileTab`

Menampilkan nama, email, dan avatar dari `ProfileService.get`. Tombol *logout* memanggil `AuthService.logout` lalu memindahkan pengguna ke `LoginScreen` menggunakan `Navigator.pushAndRemoveUntil`.

## 4.7 Penanganan Kesalahan dan State

- Seluruh pemanggilan API di-*wrap* `try/catch` pada layer UI untuk menangkap `ApiException`.
- Kegagalan jaringan generik ditampilkan sebagai `SnackBar` atau tampilan retry.
- `FutureBuilder` menjadi mekanisme utama untuk merepresentasikan tiga *state*: *loading*, *error*, *data*.
- Sinkronisasi antar-tab (mis. `InventoryTab` ↔ `AddTab`) menggunakan `ValueNotifier` tanpa perlu *state management* pihak ketiga.

## 4.8 Pengujian

### 4.8.1 Rencana Pengujian

Pengujian dilakukan dengan pendekatan *black-box* pada tingkat fungsional dengan menjalankan aplikasi pada emulator Android dan memantau perilaku UI.

### 4.8.2 Skenario Pengujian Aplikasi

| No | Fitur | Skenario | Hasil |
|----|-------|----------|-------|
| 1 | Onboarding | Menampilkan halaman perkenalan pada instal pertama | Berhasil |
| 2 | Register | Mendaftar akun baru | Berhasil, langsung ke *dashboard* |
| 3 | Register duplikat | Email sudah terdaftar | `SnackBar` error muncul |
| 4 | Login sukses | Login dengan kredensial valid | Token tersimpan, ke *dashboard* |
| 5 | Login gagal | *Password* salah | `SnackBar` menampilkan pesan API |
| 6 | Auto-login | Membuka aplikasi setelah *login* sebelumnya | Langsung ke *dashboard* |
| 7 | Tab Inventory | Menampilkan bahan per kategori | Warna sesuai selisih hari |
| 8 | Filter Pill Tab | Berpindah antara kulkas / freezer / rak dapur | Data ter-filter dengan benar |
| 9 | Pull-to-refresh | Menarik ke bawah untuk memuat ulang | Data ter-*update* |
| 10 | Retry saat error | Server dimatikan → tekan "Coba lagi" | Berhasil memuat ulang |
| 11 | Tambah Bahan | Memilih gambar, mengisi form, submit | Berhasil; `InventoryTab` ikut *refresh* |
| 12 | Daftar Belanja | Menambah item ke daftar belanja | Item tampil di list |
| 13 | Toggle belanja | Menandai item sudah dibeli | *Checkbox* berubah, item tersusun ke bawah |
| 14 | Notifikasi | Menampilkan notifikasi dari API | Tampil sesuai *type* |
| 15 | Grouping notifikasi | Notifikasi dikelompokkan Hari Ini/Kemarin/dsb | Berhasil |
| 16 | Profil | Menampilkan nama & email pengguna | Berhasil |
| 17 | Logout | Membersihkan token dan kembali ke *login* | Berhasil |
| 18 | Session persistence | Menutup dan membuka ulang aplikasi | Sesi tetap aktif |

### 4.8.3 Pengujian Integrasi dengan API

Verifikasi bahwa aplikasi memanggil endpoint yang tepat dilakukan dengan mengamati *log* dari `LogInterceptor` `dio` pada mode *debug*. Ringkasan hasil:

| Endpoint | Pemanggil | Status |
|----------|-----------|--------|
| `POST /auth/register` | `RegisterScreen` | ✔ |
| `POST /auth/login` | `LoginScreen` | ✔ |
| `POST /auth/logout` | `ProfileTab` | ✔ |
| `GET /profile` | `ProfileTab` | ✔ |
| `GET /inventory` | `InventoryTab` | ✔ |
| `POST /inventory` (multipart) | `AddTab` | ✔ |
| `GET /shopping` | `AddTab` | ✔ |
| `POST /shopping` | `AddTab` | ✔ |
| `PATCH /shopping/:id/toggle` | `AddTab` | ✔ |
| `GET /notifications` | `NotificationTab` | ✔ |

## 4.9 Hasil Pengujian Keseluruhan

Dari total **18 skenario aplikasi** dan **10 verifikasi integrasi endpoint**, seluruhnya berjalan sesuai ekspektasi. Aplikasi dinilai memenuhi seluruh kebutuhan fungsional dan non-fungsional yang telah ditetapkan pada BAB III.

---

# BAB V
# PENUTUP

## 5.1 Kesimpulan

Berdasarkan analisis, perancangan, implementasi, dan pengujian yang telah dilakukan pada aplikasi *mobile* Smart Pantry berbasis Flutter, dapat ditarik kesimpulan sebagai berikut:

1. **Aplikasi Smart Pantry berhasil dibangun** menggunakan Flutter sebagai solusi digital manajemen bahan dapur berbahasa Indonesia.
2. **Arsitektur berlapis** (Presentation – Service – Data) diterapkan dengan tegas: `screens/` untuk UI, `services/` untuk konsumsi API, dan `data/models/` untuk model hasil *parsing* JSON.
3. **`ApiClient` berbasis `dio`** berhasil menyederhanakan pemanggilan API: menyisipkan JWT secara otomatis via *interceptor*, membuka envelope `{ data, message }`, dan mengubah error menjadi `ApiException` yang mudah ditangani UI.
4. **Autentikasi** menggunakan JWT yang disimpan pada `shared_preferences` melalui `TokenStorage`, sehingga sesi pengguna tetap terjaga bahkan setelah aplikasi ditutup.
5. **Fitur inventori** memuat kategorisasi tiga rak (kulkas, freezer, rak dapur), indikator warna berdasarkan sisa hari sebelum kedaluwarsa (merah/kuning/hijau), *pull-to-refresh*, dan *upload* gambar bahan melalui `image_picker` + `FormData`.
6. **Sinkronisasi antar-tab** dicapai secara sederhana menggunakan `ValueNotifier` pada `InventoryService`, tanpa perlu *state management* eksternal.
7. **Navigasi berbasis `IndexedStack`** menjaga *state* setiap tab, dan seluruh alur navigasi antar layar dibangun menggunakan `Navigator.push`/`pushReplacement`.
8. **Aplikasi hanya perlu mengetahui kontrak endpoint API** (10 endpoint pada `/v1`), tanpa perlu memahami detail *server-side*, sehingga pengembangan sisi Flutter berjalan mandiri.
9. Seluruh **skenario pengujian fungsional** dan **verifikasi integrasi endpoint** berjalan sesuai ekspektasi.

## 5.2 Saran

Meskipun aplikasi sudah berjalan dengan baik, beberapa area masih dapat dikembangkan lebih lanjut:

1. **Halaman Home dinamis** — saat ini konten Home masih statis; ke depan dapat mengambil data ringkasan dari API (bahan hampir kedaluwarsa, jumlah total item, dsb).
2. **Fitur Edit dan Hapus Inventori** — menambahkan *screen* dan pemanggilan API untuk memperbarui stok atau menghapus barang secara manual (memerlukan penambahan endpoint di sisi API).
3. **State management modern** — mempertimbangkan penggunaan Riverpod atau Bloc bila aplikasi berkembang menjadi lebih kompleks (multi-user, sinkronisasi *real-time*, dsb).
4. **Tema terpusat** — memindahkan konstanta warna ke satu berkas `theme.dart` alih-alih diduplikasi di tiap layar.
5. **Push notification** — mengintegrasikan Firebase Cloud Messaging (FCM) agar notifikasi dari API dapat sampai ke perangkat pengguna meskipun aplikasi tidak dibuka.
6. **Barcode scanner** — memanfaatkan kamera untuk memindai *barcode* produk dan mempercepat *input* bahan.
7. **Fitur pencarian** — mengaktifkan `SearchBarView` yang sudah tersedia untuk memfilter *inventory* berdasarkan nama bahan.
8. **Widget dan Unit Test** — menambahkan pengujian otomatis untuk *service class* dan widget utama guna menjamin kualitas kode dalam jangka panjang.
9. **Dukungan multi-bahasa (i18n)** — meskipun target pengguna adalah Indonesia, dukungan bahasa Inggris dapat ditambahkan untuk memperluas jangkauan.
10. **Optimasi gambar** — melakukan kompresi otomatis pada sisi klien sebelum *upload* untuk menghemat kuota data pengguna.

---

**— Selesai —**
