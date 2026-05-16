# Akademika - Sistem Informasi Mahasiswa Terpadu

![Flutter](https://img.shields.io/badge/Frontend-Flutter-blue?style=for-the-badge&logo=flutter)
![Laravel](https://img.shields.io/badge/Backend-Laravel-red?style=for-the-badge&logo=laravel)
![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)

Akademika adalah aplikasi sistem informasi akademik mahasiswa berbasis mobile (Flutter) yang terintegrasi dengan backend REST API (Laravel). Aplikasi ini dirancang untuk mempermudah pengelolaan data akademik mahasiswa, termasuk fitur Kartu Tanda Mahasiswa (KTM) Digital, asisten AI, dan pengelolaan Rencana Studi.

## 🚀 Fitur Utama

- **Otentikasi Aman**: Login mahasiswa terintegrasi dengan Laravel Sanctum.
- **KTM Digital 3D**: Kartu Tanda Mahasiswa interaktif berbasis 3D.
- **Asisten AI Akademika**: Fitur tanya jawab cerdas seputar akademik.
- **Manajemen KRS**: Pengelolaan dan tampilan Kartu Rencana Studi terstruktur berdasarkan semester.
- **CRUD Mahasiswa Lengkap**: Fitur kelola data mahasiswa, termasuk unggah foto profil (Multipart upload).
- **Dokumentasi API**: Terintegrasi otomatis menggunakan Swagger (L5-Swagger).

## 🛠️ Teknologi yang Digunakan

### Backend (REST API)
- **Framework**: Laravel 11.x
- **Autentikasi**: Laravel Sanctum
- **Dokumentasi API**: L5-Swagger (OpenAPI)
- **Database**: SQLite / MySQL

### Frontend (Mobile App)
- **Framework**: Flutter
- **HTTP Client**: `http` package
- **State Management**: Provider
- **UI/UX**: Material Design dengan kustomisasi font Poppins & Branding UNIKOM

## 📂 Struktur Proyek

Proyek ini menggunakan arsitektur monorepo sederhana yang memisahkan frontend dan backend:

- `/akademika-api` - Berisi source code backend Laravel.
- `/AkademikaFlutter` - Berisi source code frontend Flutter.

## ⚙️ Panduan Instalasi & Menjalankan Aplikasi

### 1. Menjalankan Backend (Laravel)
Pastikan PHP, Composer, dan ekstensi SQLite/MySQL sudah terinstall.

```bash
cd akademika-api
cp .env.example .env
composer install
php artisan key:generate
php artisan migrate --seed
php artisan storage:link
php artisan serve
```
> **Catatan:** API akan berjalan di `http://localhost:8000`. Dokumentasi Swagger tersedia di `http://localhost:8000/api/documentation`.

### 2. Menjalankan Frontend (Flutter)
Pastikan Flutter SDK sudah terinstall dan perangkat (emulator/fisik) sudah siap.

```bash
cd AkademikaFlutter
flutter pub get
flutter run
```
> **Catatan:** Jika menggunakan emulator Android, URL backend pada `lib/services/api_service.dart` menggunakan `10.0.2.2`. Sesuaikan dengan IP lokal jika menggunakan device fisik.

## 👨‍💻 Pengembang

Dikembangkan oleh **Akmal Putra Septian**
*Teknik Komputer 24 • Universitas Komputer Indonesia (UNIKOM)*
