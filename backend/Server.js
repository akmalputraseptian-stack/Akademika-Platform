const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const cors = require('cors');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());

// Buka/buat file database
const db = new sqlite3.Database(path.join(__dirname, 'akademika.db'));

// Buat tabel kalau belum ada
db.serialize(() => {
  db.run(`CREATE TABLE IF NOT EXISTS mahasiswa (
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
  )`);

  db.run(`CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nim TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    nama TEXT
  )`);
});

// ===== MAHASISWA =====
app.get('/api/mahasiswa', (req, res) => {
  db.all('SELECT * FROM mahasiswa ORDER BY nama ASC', [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

app.post('/api/mahasiswa', (req, res) => {
  const { nim, nama, jurusan, angkatan, email, status, gpa, sks, profilePic } = req.body;
  db.run(
    'INSERT INTO mahasiswa (nim, nama, jurusan, angkatan, email, status, gpa, sks, profilePic) VALUES (?,?,?,?,?,?,?,?,?)',
    [nim, nama, jurusan, angkatan, email, status, gpa, sks, profilePic],
    function(err) {
      if (err) return res.status(400).json({ error: 'NIM sudah terdaftar' });
      res.json({ success: true, id: this.lastID });
    }
  );
});

app.put('/api/mahasiswa/:id', (req, res) => {
  const { nim, nama, jurusan, angkatan, email, status, gpa, sks, profilePic } = req.body;
  db.run(
    'UPDATE mahasiswa SET nim=?, nama=?, jurusan=?, angkatan=?, email=?, status=?, gpa=?, sks=?, profilePic=? WHERE id=?',
    [nim, nama, jurusan, angkatan, email, status, gpa, sks, profilePic, req.params.id],
    function(err) {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ success: true });
    }
  );
});

app.delete('/api/mahasiswa/:id', (req, res) => {
  db.run('DELETE FROM mahasiswa WHERE id=?', [req.params.id], function(err) {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ success: true });
  });
});

// ===== AUTH =====
app.post('/api/register', (req, res) => {
  const { nim, password, nama } = req.body;
  db.run(
    'INSERT INTO users (nim, password, nama) VALUES (?,?,?)',
    [nim, password, nama],
    function(err) {
      if (err) return res.status(400).json({ error: 'NIM sudah terdaftar' });
      res.json({ success: true, id: this.lastID });
    }
  );
});

app.post('/api/login', (req, res) => {
  const { nim, password } = req.body;
  db.get(
    'SELECT * FROM users WHERE nim=? AND password=?',
    [nim, password],
    (err, row) => {
      if (err || !row) return res.status(401).json({ error: 'NIM atau password salah' });
      res.json({ success: true, user: row });
    }
  );
});

app.listen(3001, () => console.log('✅ Backend jalan di http://localhost:3001'));