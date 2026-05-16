# Akademika - Academic Information System

![Flutter](https://img.shields.io/badge/Frontend-Flutter-blue?style=for-the-badge&logo=flutter)
![Laravel](https://img.shields.io/badge/Backend-Laravel-red?style=for-the-badge&logo=laravel)
![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)

A mobile-first academic information system built with Flutter and backed by a Laravel RESTful API. Designed for efficient management of academic data, including digital identification, AI assistance, and study plan administration.

## Core Features

- **Secure Authentication**: Laravel Sanctum based token authentication.
- **3D Digital ID**: Interactive 3D rendering of the student identification card.
- **AI Assistant**: Integrated AI query system for academic-related contexts.
- **Study Plan Management (KRS)**: Structured viewing and management of student curriculums by semester.
- **Complete CRUD Operations**: Full student data management including multipart profile picture uploads.
- **Automated API Documentation**: OpenAPI specification generated via L5-Swagger.

## Technical Stack

### Backend (REST API)
- **Framework**: Laravel 11.x
- **Auth**: Laravel Sanctum
- **Docs**: L5-Swagger (OpenAPI)
- **Database**: SQLite / MySQL

### Frontend (Mobile Application)
- **Framework**: Flutter
- **HTTP Client**: `http`
- **State Management**: Provider
- **Design System**: Material Design (Custom Poppins Typography)

## Project Structure

A simple monorepo structure separating the client and server applications:

- `/akademika-api` - Laravel backend source code.
- `/AkademikaFlutter` - Flutter frontend source code.

## Local Development Guide

### 1. Backend Setup (Laravel)
Ensure PHP, Composer, and the required database extensions are installed.

```bash
cd akademika-api
cp .env.example .env
composer install
php artisan key:generate
php artisan migrate --seed
php artisan storage:link
php artisan serve
```
> Note: The API serves on `http://localhost:8000`. Swagger documentation is accessible at `http://localhost:8000/api/documentation`.

### 2. Frontend Setup (Flutter)
Ensure the Flutter SDK is installed and a target device is running.

```bash
cd AkademikaFlutter
flutter pub get
flutter run
```
> Note: For Android emulators, the backend URL in `lib/services/api_service.dart` defaults to `10.0.2.2`. Adjust to your local IPv4 address if testing on a physical device.

---
**Developed by Akmal Putra Septian**  
*Computer Engineering 24 • Universitas Komputer Indonesia (UNIKOM)*
