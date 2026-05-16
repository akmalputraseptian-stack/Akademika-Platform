# Laporan Tugas Pekan 5 - Integrasi API Mahasiswa
**Mata Kuliah:** Pemrograman Mobile  
**Dosen Pengampu:** [Nama Dosen]  
**Pengembang:** Akmal Putra Septian | Teknik Komputer 24 • UNIKOM  

---

## 1. Deskripsi Tugas
Tugas pekan ini fokus pada pembuatan Backend menggunakan Laravel (REST API) dan integrasinya ke aplikasi Frontend Flutter. Fitur utama mencakup operasi CRUD (Create, Read, Update, Delete) data mahasiswa, dokumentasi API menggunakan Swagger, serta implementasi fitur upload foto.

---

## 2. Implementasi Laravel API (Backend)

### A. Migration & Model
Tabel `mahasiswas` dirancang untuk menyimpan data akademik lengkap.
- **Fields:** `nim`, `nama`, `jurusan`, `angkatan`, `email`, `status`, `gpa`, `sks`, `profilePic`, `class`, `password`.
- **Model:** `Mahasiswa.php` menggunakan trait `HasApiTokens` untuk integrasi Laravel Sanctum.

### B. Controller (CRUD Lengkap)
`MahasiswaController.php` mengelola seluruh logika bisnis API:
- `index()`: Mengambil semua data mahasiswa.
- `store()`: Validasi input, pengelolaan upload file foto ke storage, dan penyimpanan data baru.
- `show($id)`: Detail satu mahasiswa berdasarkan ID.
- `update(Request $request, $id)`: Memperbarui data yang sudah ada.
- `destroy($id)`: Menghapus data mahasiswa dari database.

### C. Swagger Documentation (L5-Swagger)
Dokumentasi API otomatis dibuat menggunakan anotasi OpenApi pada controller. 
- **Endpoint Terdaftar:** Seluruh resource `/mahasiswa` (GET, POST, PUT, DELETE).
- **Akses UI:** Dapat diakses melalui browser pada path `/api/documentation`.

---

## 3. Postman Testing
Seluruh endpoint telah diuji menggunakan Postman untuk memastikan respon JSON sesuai dengan standar:
1. **GET all students**: Mengembalikan array objek mahasiswa.
2. **POST new student**: Berhasil menyimpan data dan file gambar.
3. **GET by ID**: Menampilkan detail spesifik.
4. **PUT update**: Memperbarui field nama/jurusan.
5. **DELETE**: Menghapus data secara permanen.

---

## 4. Implementasi Flutter Integration (Frontend)

### A. Daftar Mahasiswa (ListView)
Halaman `student_list_screen.dart` menampilkan data secara real-time dari API.
- **Loading State:** Menggunakan `CircularProgressIndicator` saat fetching data.
- **RefreshIndicator:** Fitur "Pull to Refresh" untuk memuat ulang data terbaru.
- **ListView.builder:** Digunakan untuk performa rendering daftar yang efisien.

### B. Form Tambah & Upload Foto (Bonus)
Halaman `mahasiswa_form_screen.dart` memungkinkan penambahan data mahasiswa baru.
- **Image Picker:** Integrasi galeri untuk memilih foto profil.
- **Multipart Request:** Menggunakan `http.MultipartRequest` untuk mengirim data teks dan file sekaligus ke server Laravel.

---

## 5. Panduan Menjalankan Aplikasi

### Backend (Laravel)
1. Buka folder `akademika-api`.
2. Jalankan perintah: `php artisan serve`.
3. Pastikan database SQLite/MySQL sudah terkonfigurasi di `.env`.
4. Link Storage: `php artisan storage:link`.

### Frontend (Flutter)
1. Buka folder `AkademikaFlutter`.
2. Sesuaikan `baseUrl` di `lib/services/api_service.dart` dengan IP laptop (jika menggunakan device fisik) atau `10.0.2.2` (untuk emulator).
3. Jalankan perintah: `flutter run`.

---

## 6. Identitas & Branding
Aplikasi ini merupakan bagian dari ekosistem **AKADEMIKA UNIKOM**.
- **Logo:** Menggunakan versi High Resolution Transparan UNIKOM 2025.
- **Font:** Poppins (Regular, Bold, Ultra Bold).
- **Kredit:** "Developed by Akmal Putra Septian | Teknik Komputer 24 • UNIKOM" tercantum pada footer aplikasi.

---
**Status:** Selesai & Siap Demo.
