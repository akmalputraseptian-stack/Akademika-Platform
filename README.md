<div align="center">

# Akademika Platform

**A Next-Generation Academic Information System**

[![Flutter](https://img.shields.io/badge/Frontend-Flutter_3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Laravel](https://img.shields.io/badge/Backend-Laravel_11.x-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)](https://laravel.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

*Streamlining student administration with mobile-first architecture, AI integration, and interactive 3D elements.*

</div>

---

## Table of Contents
- [About the Project](#about-the-project)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [API Documentation](#api-documentation)
- [Developer](#developer)

---

## About the Project

**Akademika Platform** is an integrated mobile and backend solution designed to manage university student data efficiently. By leveraging the power of **Flutter** for a seamless cross-platform mobile experience and **Laravel** for a robust, secure RESTful API, this platform modernizes traditional academic administration.

It goes beyond basic CRUD operations by introducing features like a **3D Digital ID Card (KTM)** and an **AI-powered Academic Assistant**, wrapped in a sleek, customized Material Design interface matching university branding guidelines.

---

## Key Features

| Feature | Description |
| :--- | :--- |
| **Secure Auth** | Token-based authentication utilizing Laravel Sanctum. |
| **3D Digital ID** | An interactive, 3D-rendered student identification card. |
| **AI Assistant** | Integrated AI query system to assist students with academic contexts. |
| **Study Plan (KRS)** | Structured viewing and management of student curriculums by semester. |
| **Complete CRUD** | Full student data management, including multipart profile picture uploads. |
| **Auto API Docs** | OpenAPI specification generated automatically via L5-Swagger. |

---

## Tech Stack

### Client (Mobile App)
- **Framework:** Flutter
- **State Management:** Provider
- **Networking:** `http` package
- **Design System:** Material Design with Custom Poppins Typography

### Server (REST API)
- **Framework:** Laravel 11.x
- **Authentication:** Laravel Sanctum
- **Documentation:** L5-Swagger (OpenAPI 3.0)
- **Database:** SQLite / MySQL ready

---

## Architecture

The repository uses a straightforward monorepo structure to keep both ends of the platform unified:

```text
Akademika-Platform/
├── akademika-api/       # Laravel backend application
│   ├── app/Models/      # Eloquent ORM Models
│   ├── app/Http/        # Controllers & Middleware
│   └── routes/          # API & Web routes
└── AkademikaFlutter/    # Flutter mobile application
    ├── lib/screens/     # UI Views
    ├── lib/services/    # API & External integrations
    └── lib/models/      # Dart data classes
```

---

## Getting Started

Follow these instructions to set up the project locally on your machine.

### 1. Server Setup (Laravel)
Ensure you have PHP (>= 8.2) and Composer installed.

```bash
# Navigate to the backend directory
cd akademika-api

# Duplicate the environment file
cp .env.example .env

# Install PHP dependencies
composer install

# Generate application key & prepare database
php artisan key:generate
php artisan migrate --seed
php artisan storage:link

# Start the local development server
php artisan serve
```
> The API will be available at `http://localhost:8000`.

### 2. Client Setup (Flutter)
Ensure you have the Flutter SDK installed and an emulator running (or a physical device connected).

```bash
# Navigate to the frontend directory
cd AkademikaFlutter

# Fetch Dart dependencies
flutter pub get

# Run the application
flutter run
```
> **Note for Android Emulators:** The default backend URL in `lib/services/api_service.dart` is set to `http://10.0.2.2:8000`. If you are using a physical device, update this to your machine's local IPv4 address.

---

## API Documentation

This project uses Swagger for interactive API documentation. 
Once the Laravel server is running, you can access the complete OpenAPI documentation at:

`http://localhost:8000/api/documentation`

---

## Developer

Developed with precision by:

**Akmal Putra Septian**  
*Computer Engineering '24 • Universitas Komputer Indonesia (UNIKOM)*
