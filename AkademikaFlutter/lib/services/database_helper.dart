import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
// Import universal_io or conditional imports if strictly needed for File operations, 
// but here we just need to bypass logic on Web. Since File is used for copying assets to path, 
// and sqflite isn't natively supported on Web anyway, we'll avoid dart:io imports entirely and mock File if possible, 
// OR use an interface. For now, since this is heavily dependent on dart:io, 
// we will just fix the top level Platform calls that break the app compilation on web immediately.
// We must keep dart:io for File and Directory but we will NOT call Platform on web.
import 'dart:io' as io;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('akademika.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String path;

    if (kIsWeb) {
      throw UnsupportedError("SQLite is not supported on the Web platform natively without sqflite_common_ffi_web.");
    } else if (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS) {
      // Initialize FFI for Desktop
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      
      // Try to use the user's specific path first, if it exists
      const userPath = "D:\\Dokumen dan Sertifikat Penting\\Kuliah\\Semester 4\\Pemrograman Mobile\\Pekan 5\\Akademika\\backend\\akademika.db";
      if (io.File(userPath).existsSync()) {
        path = userPath;
      } else {
        // Fallback to a local path in the project directory
        final exePath = io.Platform.resolvedExecutable;
        final exeDir = io.Directory(exePath).parent.path;
        path = join(exeDir, filePath);

        // Copy from assets if not exists
        if (!io.File(path).existsSync()) {
          try {
            ByteData data = await rootBundle.load(join("assets", "akademika.db"));
            List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
            await io.File(path).writeAsBytes(bytes, flush: true);
          } catch (e) {
            debugPrint("Error copying database from assets: $e");
          }
        }
      }
    } else {
      // Standard path for Mobile (Android/iOS)
      final dbPath = await getDatabasesPath();
      path = join(dbPath, filePath);
      
      // KARENA KITA MENGGUNAKAN FILE SQLITE EKSTERNAL,
      // Kita "paksa" copy/timpa database di memori HP dengan file dari assets 
      // agar setiap ada data baru dari DB Browser (seperti Alfarizi) bisa langsung terbaca.
      try {
        await io.Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
        
      ByteData data = await rootBundle.load(join("assets", "akademika.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      
      await io.File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS mahasiswa (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nim TEXT NOT NULL UNIQUE,
        nama TEXT NOT NULL,
        jurusan TEXT NOT NULL,
        angkatan TEXT NOT NULL,
        email TEXT,
        status TEXT,
        gpa TEXT,
        sks TEXT,
        profilePic TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nim TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        nama TEXT
      )
    ''');
  }

  // === Auth Operations (users table) ===
  
  Future<Map<String, dynamic>?> login(String nim, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'nim = ? AND password = ?',
      whereArgs: [nim, password],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<void> registerUser(String nim, String password, String nama) async {
    final db = await instance.database;
    await db.insert('users', {
      'nim': nim,
      'password': password,
      'nama': nama,
    });
  }

  // === Data Operations (mahasiswa table) ===

  Future<void> registerMahasiswa(Map<String, dynamic> row) async {
    final db = await instance.database;
    await db.insert('mahasiswa', row);
  }

  Future<Map<String, dynamic>?> getMahasiswa(String nim) async {
    final db = await instance.database;
    final maps = await db.query(
      'mahasiswa',
      where: 'nim = ?',
      whereArgs: [nim],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<int> updateMahasiswa(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update(
      'mahasiswa',
      row,
      where: 'nim = ?',
      whereArgs: [row['nim']],
    );
  }
}
