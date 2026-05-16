import express from "express";
import path from "path";
import { fileURLToPath } from "url";
import { createServer as createViteServer } from "vite";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function startServer() {
  const app = express();
  const PORT = 3000;

  app.use(express.json());

  // Mock Database in memory (replaces the missing SQL.js for now)
  let mahasiswa = [
    {
      id: 1,
      nim: '10824012',
      nama: 'Budi Santoso',
      jurusan: 'Informatics Engineering',
      angkatan: '2024',
      email: 'budi.santoso@university.ac.id',
      status: 'Aktif',
      gpa: '3.92',
      sks: '120',
      profilePic: 'https://picsum.photos/seed/student_budi/400/400',
      class: 'A'
    }
  ];

  // API Routes
  app.get("/api/mahasiswa", (req, res) => {
    res.json(mahasiswa);
  });

  app.post("/api/mahasiswa", (req, res) => {
    const newData = { id: Date.now(), ...req.body };
    mahasiswa.push(newData);
    res.status(201).json(newData);
  });

  app.put("/api/mahasiswa/:id", (req, res) => {
    const { id } = req.params;
    const index = mahasiswa.findIndex(m => m.id === parseInt(id));
    if (index !== -1) {
      mahasiswa[index] = { ...mahasiswa[index], ...req.body };
      res.json(mahasiswa[index]);
    } else {
      res.status(404).json({ message: "Not found" });
    }
  });

  app.delete("/api/mahasiswa/:id", (req, res) => {
    const { id } = req.params;
    mahasiswa = mahasiswa.filter(m => m.id !== parseInt(id));
    res.status(204).send();
  });

  app.post("/api/register", (req, res) => {
    const { nim, pass, nama } = req.body;
    const newUser = {
      id: Date.now(),
      nim,
      nama,
      jurusan: 'Unknown',
      angkatan: '2024',
      email: `${nim}@university.ac.id`,
      status: 'Aktif',
      gpa: '0.00',
      sks: '0',
      profilePic: '',
      class: 'A'
    };
    mahasiswa.push(newUser);
    res.status(201).json({ user: newUser });
  });

  app.post("/api/login", (req, res) => {
    const { nim, pass } = req.body;
    const user = mahasiswa.find(m => m.nim === nim);
    if (user) {
      // In a real app, verify password here
      res.json({ user });
    } else {
      res.status(401).json({ message: "Invalid credentials" });
    }
  });

  // Vite middleware for development
  if (process.env.NODE_ENV !== "production") {
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: "spa",
    });
    app.use(vite.middlewares);
  } else {
    const distPath = path.join(process.cwd(), "dist");
    app.use(express.static(distPath));
    app.get("*", (req, res) => {
      res.sendFile(path.join(distPath, "index.html"));
    });
  }

  app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server running on http://localhost:${PORT}`);
  });
}

startServer();
