const BASE_URL = 'http://localhost:3001/api';

export interface Mahasiswa {
  id?: number;
  nim: string;
  nama: string;
  jurusan: string;
  angkatan: string;
  email: string;
  status?: string;
  gpa?: string;
  sks?: string;
  profilePic?: string;
  class?: string;
}

export async function initDatabase() {
  try {
    const response = await fetch(`${BASE_URL}/mahasiswa`);
    if (!response.ok) throw new Error('Backend not reachable');
    console.log('Backend connected');
  } catch (err) {
    console.error('Backend connection failed:', err);
  }
  return true;
}

export async function getAllMahasiswa(): Promise<Mahasiswa[]> {
  const response = await fetch(`${BASE_URL}/mahasiswa`);
  if (!response.ok) throw new Error('Failed to fetch mahasiswa');
  return await response.json();
}

export async function getMahasiswaByNim(nim: string): Promise<Mahasiswa | null> {
  const all = await getAllMahasiswa();
  return all.find(m => m.nim === nim) || null;
}

export async function tambahMahasiswa(m: Mahasiswa) {
  const response = await fetch(`${BASE_URL}/mahasiswa`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(m)
  });
  if (!response.ok) throw new Error('Failed to add mahasiswa');
  return await response.json();
}

export async function updateMahasiswa(idOrNim: string | number, m: Partial<Mahasiswa>) {
  let id = idOrNim;
  if (typeof idOrNim === 'string') {
    const current = await getMahasiswaByNim(idOrNim);
    if (!current || !current.id) throw new Error('Mahasiswa not found or has no ID');
    id = current.id;
  }
  const response = await fetch(`${BASE_URL}/mahasiswa/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(m)
  });
  if (!response.ok) throw new Error('Failed to update mahasiswa');
  return await response.json();
}

export async function hapusMahasiswa(idOrNim: string | number) {
  let id = idOrNim;
  if (typeof idOrNim === 'string') {
    const current = await getMahasiswaByNim(idOrNim);
    if (!current || !current.id) throw new Error('Mahasiswa not found or has no ID');
    id = current.id;
  }
  const response = await fetch(`${BASE_URL}/mahasiswa/${id}`, {
    method: 'DELETE'
  });
  if (!response.ok) throw new Error('Failed to delete mahasiswa');
}

export async function registerUser(nim: string, pass: string, nama: string) {
  const response = await fetch(`${BASE_URL}/register`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ nim, password: pass, nama })
  });
  if (!response.ok) throw new Error('Registration failed');
  return await response.json();
}

export async function loginUser(nim: string, pass: string) {
  const response = await fetch(`${BASE_URL}/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ nim, password: pass })
  });
  if (!response.ok) throw new Error('Login failed');
  return await response.json();
}