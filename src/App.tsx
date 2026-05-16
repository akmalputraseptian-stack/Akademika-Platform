/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import { useState, useEffect, FormEvent } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import * as academicDb from './database/db';
import { 
  User as UserIcon, 
  Lock, 
  Badge, 
  School, 
  ArrowLeft, 
  Menu, 
  LogOut, 
  Calendar, 
  MapPin,
  Megaphone,
  CheckCircle,
  Camera,
  Save,
  ChevronDown,
  LayoutGrid,
  BookOpen,
  Loader2,
  UserPlus,
  Key,
  RefreshCw,
  Bell,
  X,
  Clock,
  ChevronRight,
  TrendingUp,
  Award,
  Sparkles,
  Search,
  MessageSquare,
  Bot
} from 'lucide-react';

/**
 * TYPES & MOCK DATA
 */
interface StudentData {
  nim: string;
  name: string;
  class: string;
  prodi: string;
  year: string;
  profilePic: string;
  status: 'Aktif' | 'Online' | 'Libur';
  gpa: string;
  sks: string;
}

function mahasiswaToStudent(m: academicDb.Mahasiswa): StudentData {
  return {
    nim: m.nim,
    name: m.nama,
    prodi: m.jurusan,
    year: m.angkatan,
    status: (m.status as any) || 'Aktif',
    gpa: m.gpa || '0.00',
    sks: m.sks || '0',
    profilePic: m.profilePic || '',
    class: m.class || 'A'
  };
}

interface Course {
  id: string;
  day: string;
  time: string;
  title: string;
  code: string;
  room: string;
  lecturer: string;
  isToday?: boolean;
}

interface News {
  id: string;
  title: string;
  category: string;
  description: string;
  image: string;
  date: string;
}

const COURSES: Course[] = [
  { id: '1', day: 'Senin', time: '08:00 - 10:30', title: 'Data Structures & Algorithms', code: 'CS301', room: 'Ruang A204', lecturer: 'Dr. Reza', isToday: true },
  { id: '2', day: 'Senin', time: '13:00 - 15:30', title: 'Web Development', code: 'CS305', room: 'Lab Komputer B', lecturer: 'Prof. Anita S.', isToday: true },
  { id: '3', day: 'Selasa', time: '09:00 - 11:30', title: 'Database Systems', code: 'CS308', room: 'Ruang C102', lecturer: 'Budi W., M.Kom' },
  { id: '4', day: 'Rabu', time: '10:00 - 12:30', title: 'Artificial Intelligence', code: 'CS402', room: 'Ruang B301', lecturer: 'Dr. Sarah' },
];

const NEWS: News[] = [
  { 
    id: '1', 
    title: 'Pendaftaran Tech Summit 2026 Telah Dibuka!', 
    category: 'Kegiatan Mahasiswa', 
    description: 'Jadilah bagian dari revolusi teknologi di kampus kita dengan mengikuti konferensi teknologi terbesar tahun ini.',
    image: 'https://picsum.photos/seed/tech/600/400',
    date: '21 Apr 2026'
  },
  { 
    id: '2', 
    title: 'Beasiswa Unggulan Semester Genap', 
    category: 'Akademik', 
    description: 'Dibuka kesempatan beasiswa bagi mahasiswa berprestasi dengan IPK di atas 3.75.',
    image: 'https://picsum.photos/seed/scholarship/600/400',
    date: '20 Apr 2026'
  }
];

interface AcademicRecord {
  semester: number;
  gpa: string;
  ips: string;
  sks: number;
}

const ACADEMIC_RECORDS: AcademicRecord[] = [
  { semester: 1, ips: '3.75', gpa: '3.75', sks: 20 },
  { semester: 2, ips: '3.88', gpa: '3.81', sks: 22 },
  { semester: 3, ips: '3.92', gpa: '3.85', sks: 24 },
];

interface CalendarEvent {
  id: string;
  date: string;
  title: string;
  type: 'academic' | 'holiday' | 'event';
}

const CALENDAR_EVENTS: CalendarEvent[] = [
  { id: '1', date: '21 Apr 2026', title: 'Awal Perkuliahan', type: 'academic' },
  { id: '2', date: '01 Mei 2026', title: 'Hari Buruh', type: 'holiday' },
  { id: '3', date: '15 Mei 2026', title: 'UTS Semester Genap', type: 'academic' },
  { id: '4', date: '22 Mei 2026', title: 'Webinar AI Nasional', type: 'event' },
];

const DEFAULT_STUDENT: StudentData = {
  nim: '10824012',
  name: 'Budi Santoso',
  class: 'A',
  prodi: 'Informatics Engineering',
  year: '2024',
  profilePic: 'https://picsum.photos/seed/student_budi/400/400',
  status: 'Aktif',
  gpa: '3.92',
  sks: '120'
};

type View = 'login' | 'dashboard' | 'profile' | 'register' | 'forgotPassword' | 'academic' | 'calendar' | 'aiAssistant';

/**
 * MAIN COMPONENT
 */
export default function App() {
  const [view, setView] = useState<View>('login');
  const [user, setUser] = useState<StudentData | null>(null);
  const [isInitializing, setIsInitializing] = useState(true);

  // Initialize Session
  useEffect(() => {
    async function init() {
      try {
        console.log('App: Initializing Data...');
        const db = await academicDb.initDatabase();
        console.log('App: Database Initialized', db);
        
        const loggedInNim = localStorage.getItem('akademika_session_nim');
        console.log('App: Current Session NIM ->', loggedInNim);
        
        if (loggedInNim) {
          const userData = await academicDb.getMahasiswaByNim(loggedInNim);
          console.log('App: User Data Retrieved', userData);
          if (userData) {
            setUser(mahasiswaToStudent(userData));
            setView('dashboard');
          }
        }
      } catch (error) {
        console.error('App: Initialization Critical Error!', error);
        // Fallback or alert user
      } finally {
        setIsInitializing(false);
      }
    }
    init();

    // Global debug catcher
    const handleError = (e: ErrorEvent) => {
      console.error('Global Error Detected:', e.message, e.error);
    };
    window.addEventListener('error', handleError);
    return () => window.removeEventListener('error', handleError);
  }, []);

  const handleLogin = async (username: string, password?: string) => {
    try {
      // Use real login API if password provided
      if (password) {
        const result = await academicDb.loginUser(username, password);
        if (result && result.user) {
          setUser(mahasiswaToStudent(result.user));
          localStorage.setItem('akademika_session_nim', username);
          setView('dashboard');
          return;
        }
      } else {
        // Fallback for session restore (init)
        const userData = await academicDb.getMahasiswaByNim(username);
        if (userData) {
          setUser(mahasiswaToStudent(userData));
          localStorage.setItem('akademika_session_nim', username);
          setView('dashboard');
          return;
        }
      }
      alert('Login gagal! NIM atau Password salah.');
    } catch (error) {
      console.error('Login error:', error);
      alert('Terjadi kesalahan saat login.');
    }
  };

  const handleRegisterSuccess = async (newData: StudentData, pass: string) => {
    try {
      await academicDb.registerUser(newData.nim, pass, newData.name);
      alert('Registrasi berhasil! Silakan login.');
      setView('login');
    } catch (error) {
      console.error('Registration error:', error);
      alert('Registrasi gagal.');
    }
  };

  const handleResetPassword = (newPass: string) => {
    // localStorage.setItem('akademika_password', newPass); // Removing localStorage as per req
    setView('login');
  };

  const handleLogout = async () => {
    localStorage.removeItem('akademika_session_nim');
    setUser(null);
    setView('login');
  };

  const handleUpdateUser = async (updatedData: StudentData) => {
    setUser(updatedData);
    await academicDb.updateMahasiswa(updatedData.nim, {
      nama: updatedData.name,
      jurusan: updatedData.prodi,
      angkatan: updatedData.year,
      status: updatedData.status,
      gpa: updatedData.gpa,
      sks: updatedData.sks,
      profilePic: updatedData.profilePic,
      class: updatedData.class
    });
  };

  const navigateTo = (newView: View) => {
    setView(newView);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  if (isInitializing) {
    return (
      <div className="min-h-screen bg-background flex flex-col items-center justify-center">
        <Logo size="lg" className="animate-pulse" />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background font-sans text-on-surface selection:bg-primary/20">
      <AnimatePresence mode="wait">
        {view === 'login' && (
          <LoginView 
            key="login" 
            onLogin={handleLogin} 
            onRegisterClick={() => setView('register')} 
            onForgotPasswordClick={() => setView('forgotPassword')}
          />
        )}
        {view === 'register' && (
          <RegisterView 
            key="register" 
            onRegisterSuccess={handleRegisterSuccess}
            onBack={() => setView('login')}
          />
        )}
        {view === 'forgotPassword' && (
          <ForgotPasswordView 
            key="forgotPassword"
            onResetSuccess={handleResetPassword}
            onBack={() => setView('login')}
          />
        )}
        {view === 'dashboard' && user && (
          <DashboardView 
            key="dashboard" 
            user={user}
            onProfileClick={() => navigateTo('profile')}
            onNavigate={navigateTo}
            onLogout={handleLogout}
          />
        )}
        {view === 'profile' && user && (
          <ProfileView 
            key="profile" 
            user={user}
            onUpdate={handleUpdateUser}
            onBack={() => navigateTo('dashboard')}
          />
        )}
        {view === 'academic' && user && (
          <AcademicView 
            key="academic"
            user={user}
            onBack={() => navigateTo('dashboard')}
          />
        )}
        {view === 'calendar' && user && (
          <AcademicCalendarView 
            key="calendar"
            onBack={() => navigateTo('dashboard')}
          />
        )}
        {view === 'aiAssistant' && user && (
          <AIAssistantView 
            key="aiAssistant"
            user={user}
            courses={COURSES}
            onBack={() => navigateTo('dashboard')}
          />
        )}
      </AnimatePresence>

      {(view === 'dashboard' || view === 'profile' || view === 'academic' || view === 'calendar' || view === 'aiAssistant') && (
        <BottomNavBar activeView={view} onViewChange={navigateTo} />
      )}
    </div>
  );
}

/**
 * LOGIN VIEW
 */
interface LoginViewProps {
  onLogin: (uname: string, pass: string) => void;
  onRegisterClick: () => void;
  onForgotPasswordClick: () => void;
  key?: string;
}

function LoginView({ onLogin, onRegisterClick, onForgotPasswordClick }: LoginViewProps) {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setError('');

    if (!username || !password) {
      setError('Username and password are required.');
      return;
    }

    setIsLoading(true);

    try {
      await onLogin(username, password);
    } catch (err) {
      setError('Login failed. Please check your credentials.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <motion.main 
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, scale: 0.95 }}
      className="flex min-h-screen flex-col items-center justify-center p-6 relative overflow-hidden"
    >
      <div className="absolute top-[-10%] left-[-10%] w-96 h-96 bg-primary/10 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute bottom-[-10%] right-[-10%] w-[30rem] h-[30rem] bg-secondary-container/30 rounded-full blur-3xl pointer-events-none" />

      <div className="w-full max-w-md relative z-10 flex flex-col items-center">
        <header className="mb-10 flex flex-col items-center text-center">
          <Logo size="lg" stack className="mb-4" />
          <p className="text-on-surface-variant text-sm mt-1 font-medium tracking-wide">Portal Akademik Terpadu</p>
        </header>

        <div className="w-full bg-surface-container-lowest rounded-[2rem] p-8 shadow-[0_32px_64px_-16px_rgba(44,51,57,0.12)] flex flex-col space-y-6">
          <h2 className="font-headline text-2xl font-bold text-on-surface">Masuk Akun</h2>
          
          <form className="space-y-4" onSubmit={handleSubmit}>
            {error && (
              <motion.div 
                initial={{ opacity: 0, x: -10 }}
                animate={{ opacity: 1, x: 0 }}
                className="bg-error-container/20 text-error text-xs font-semibold p-3 rounded-lg border border-error/10 flex items-center gap-2"
              >
                <div className="w-1 h-4 bg-error rounded-full" />
                {error}
              </motion.div>
            )}

            <div className="space-y-1">
              <label className="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant ml-1">Username / NIM</label>
              <div className="relative">
                <UserIcon className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-outline-variant" />
                <input 
                  type="text" 
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  placeholder="Masukkan NIM Anda"
                  className="w-full bg-surface-container text-on-surface rounded-xl py-3.5 pl-12 pr-4 border-none outline-none focus:ring-4 focus:ring-primary/10 focus:bg-surface-container-lowest transition-all placeholder:text-outline-variant/60"
                />
              </div>
            </div>

            <div className="space-y-1">
              <div className="flex justify-between items-center ml-1">
                <label className="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant">Password</label>
                <button type="button" className="text-xs text-primary font-bold hover:underline" onClick={onForgotPasswordClick}>Lupa Password?</button>
              </div>
              <div className="relative">
                <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-outline-variant" />
                <input 
                  type="password" 
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="Masukkan password Anda"
                  className="w-full bg-surface-container text-on-surface rounded-xl py-3.5 pl-12 pr-4 border-none outline-none focus:ring-4 focus:ring-primary/10 focus:bg-surface-container-lowest transition-all placeholder:text-outline-variant/60"
                />
              </div>
            </div>

            <div className="pt-4 flex flex-col space-y-3">
              <button 
                type="submit"
                disabled={isLoading}
                className="w-full bg-primary text-on-primary font-headline font-bold py-4 rounded-2xl shadow-lg shadow-primary/20 hover:opacity-90 active:scale-[0.98] disabled:opacity-50 transition-all flex items-center justify-center gap-2"
              >
                {isLoading ? <Loader2 className="w-5 h-5 animate-spin" /> : 'Login'}
              </button>
              <button 
                type="button"
                className="w-full bg-secondary-container text-on-secondary-container font-headline font-semibold py-4 rounded-2xl hover:bg-secondary-fixed transition-colors active:scale-[0.98] transition-all"
                onClick={onRegisterClick}
              >
                Register
              </button>
            </div>
          </form>
        </div>

        <footer className="mt-10 text-center">
          <p className="text-xs text-outline-variant font-medium tracking-wide">© 2026 Portal Akademik Akademika</p>
        </footer>
      </div>
    </motion.main>
  );
}

/**
 * REGISTER VIEW
 */
function RegisterView({ onRegisterSuccess, onBack }: { onRegisterSuccess: (data: StudentData, pass: string) => void, onBack: () => void, key?: string }) {
  const [formData, setFormData] = useState({
    nim: '',
    name: '',
    password: '',
    prodi: 'Information Systems',
    class: 'A',
    year: '2024'
  });
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    setError('');

    if (!formData.nim || !formData.name || !formData.password) {
      setError('Harap isi semua bidang yang wajib.');
      return;
    }

    setIsLoading(true);

    // Simulated Registration
    setTimeout(() => {
      const newStudent: StudentData = {
        nim: formData.nim,
        name: formData.name,
        class: formData.class,
        prodi: formData.prodi,
        year: formData.year,
        profilePic: `https://picsum.photos/seed/student_${formData.nim}/400/400`,
        status: 'Aktif',
        gpa: '0.00',
        sks: '0'
      };
      
      onRegisterSuccess(newStudent, formData.password);
      setIsLoading(false);
    }, 2000);
  };

  return (
    <motion.main 
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20 }}
      className="flex min-h-screen flex-col items-center bg-background p-6 overflow-y-auto"
    >
      <div className="w-full max-w-md my-8">
        <header className="mb-8 flex flex-col items-center text-center">
          <div className="w-12 h-12 bg-primary rounded-xl flex items-center justify-center mb-4">
            <UserPlus className="w-6 h-6 text-on-primary" />
          </div>
          <h1 className="font-headline text-2xl font-extrabold tracking-tight text-primary uppercase">Registrasi Mahasiswa</h1>
          <p className="text-on-surface-variant text-xs mt-1">Daftarkan akun portal akademik Anda</p>
        </header>

        <div className="bg-surface-container-lowest rounded-[2rem] p-8 shadow-xl border border-outline-variant/10 space-y-6">
          <form className="space-y-4" onSubmit={handleSubmit}>
            {error && (
              <div className="bg-error-container/20 text-error text-xs font-bold p-3 rounded-lg border border-error/10">
                {error}
              </div>
            )}

            <div className="space-y-1">
              <label className="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant ml-1">NIM (Nomor Induk Mahasiswa)</label>
              <div className="relative">
                <Badge className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-outline-variant" />
                <input 
                  type="text" 
                  value={formData.nim}
                  onChange={(e) => setFormData({...formData, nim: e.target.value})}
                  placeholder="Contoh: 12045678"
                  className="w-full bg-surface-container text-on-surface rounded-xl py-3 pl-12 pr-4 text-sm outline-none focus:ring-2 focus:ring-primary/20"
                />
              </div>
            </div>

            <div className="space-y-1">
              <label className="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant ml-1">Nama Lengkap</label>
              <div className="relative">
                <UserIcon className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-outline-variant" />
                <input 
                  type="text" 
                  value={formData.name}
                  onChange={(e) => setFormData({...formData, name: e.target.value})}
                  placeholder="Masukkan nama sesuai KTP"
                  className="w-full bg-surface-container text-on-surface rounded-xl py-3 pl-12 pr-4 text-sm outline-none focus:ring-2 focus:ring-primary/20"
                />
              </div>
            </div>

            <div className="space-y-1">
              <label className="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant ml-1">Buat Password</label>
              <div className="relative">
                <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-outline-variant" />
                <input 
                  type="password" 
                  value={formData.password}
                  onChange={(e) => setFormData({...formData, password: e.target.value})}
                  placeholder="Minimal 6 karakter"
                  className="w-full bg-surface-container text-on-surface rounded-xl py-3 pl-12 pr-4 text-sm outline-none focus:ring-2 focus:ring-primary/20"
                />
              </div>
            </div>

            <div className="grid grid-cols-2 gap-3">
              <div className="space-y-1">
                <label className="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant ml-1">Kelas</label>
                <select 
                  value={formData.class}
                  onChange={(e) => setFormData({...formData, class: e.target.value})}
                  className="w-full bg-surface-container text-on-surface rounded-xl py-3 px-4 text-sm outline-none focus:ring-2 focus:ring-primary/20 appearance-none"
                >
                  {['A', 'B', 'C', 'D'].map(c => <option key={c} value={c}>Kelas {c}</option>)}
                </select>
              </div>
              <div className="space-y-1">
                <label className="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant ml-1">Tahun Angkatan</label>
                <select 
                  value={formData.year}
                  onChange={(e) => setFormData({...formData, year: e.target.value})}
                  className="w-full bg-surface-container text-on-surface rounded-xl py-3 px-4 text-sm outline-none focus:ring-2 focus:ring-primary/20 appearance-none"
                >
                  {['2021', '2022', '2023', '2024'].map(y => <option key={y} value={y}>{y}</option>)}
                </select>
              </div>
            </div>

            <div className="space-y-1">
              <label className="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant ml-1">Program Studi</label>
              <select 
                value={formData.prodi}
                onChange={(e) => setFormData({...formData, prodi: e.target.value})}
                className="w-full bg-surface-container text-on-surface rounded-xl py-3 px-4 text-sm outline-none focus:ring-2 focus:ring-primary/20 appearance-none"
              >
                {['Information Systems', 'Computer Science', 'Data Science', 'Informatika'].map(p => <option key={p} value={p}>{p}</option>)}
              </select>
            </div>

            <div className="pt-4 space-y-3">
              <button 
                type="submit"
                disabled={isLoading}
                className="w-full bg-primary text-on-primary font-headline font-bold py-4 rounded-2xl shadow-lg shadow-primary/20 hover:opacity-90 active:scale-[0.98] disabled:opacity-50 transition-all flex items-center justify-center gap-2"
              >
                {isLoading ? <Loader2 className="w-5 h-5 animate-spin" /> : 'Selesaikan Registrasi'}
              </button>
              <button 
                type="button"
                onClick={onBack}
                className="w-full text-primary font-headline font-bold py-2 hover:bg-surface-container rounded-xl transition-all"
              >
                Kembali ke Login
              </button>
            </div>
          </form>
        </div>
      </div>
    </motion.main>
  );
}

/**
 * FORGOT PASSWORD VIEW
 */
function ForgotPasswordView({ onResetSuccess, onBack }: { onResetSuccess: (pass: string) => void, onBack: () => void, key?: string }) {
  const [nim, setNim] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [viewState, setViewState] = useState<'verify' | 'reset'>('verify');

  const handleVerify = async (e: FormEvent) => {
    e.preventDefault();
    setError('');

    if (!nim) {
      setError('Harap masukkan NIM Anda.');
      return;
    }

    setIsLoading(true);

    try {
      const userData = await academicDb.getMahasiswaByNim(nim);
      if (userData) {
        setViewState('reset');
      } else {
        setError('NIM tidak terdaftar di sistem kami.');
      }
    } catch (err) {
      setError('Gagal memverifikasi akun.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleReset = (e: FormEvent) => {
    e.preventDefault();
    setError('');

    if (newPassword.length < 6) {
      setError('Password minimal 6 karakter.');
      return;
    }

    if (newPassword !== confirmPassword) {
      setError('Konfirmasi password tidak cocok.');
      return;
    }

    setIsLoading(true);

    // Simulate reset
    setTimeout(() => {
      onResetSuccess(newPassword);
      setIsLoading(false);
    }, 2000);
  };

  return (
    <motion.main 
      initial={{ opacity: 0, scale: 0.95 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={{ opacity: 0, scale: 0.95 }}
      className="flex min-h-screen flex-col items-center justify-center bg-background p-6"
    >
      <div className="w-full max-w-md">
        <header className="mb-8 flex flex-col items-center text-center">
          <div className="w-16 h-16 bg-error-container/20 rounded-2xl flex items-center justify-center mb-6">
            <Key className="w-8 h-8 text-error" />
          </div>
          <h1 className="font-headline text-3xl font-extrabold tracking-tight text-on-surface">Lupa Password?</h1>
          <p className="text-on-surface-variant text-sm mt-2">
            {viewState === 'verify' 
              ? 'Masukkan NIM Anda untuk memverifikasi akun.' 
              : 'Akun terverifikasi! Silakan buat password baru.'}
          </p>
        </header>

        <div className="bg-surface-container-lowest rounded-[2.5rem] p-8 shadow-2xl border border-outline-variant/10">
          <form className="space-y-6" onSubmit={viewState === 'verify' ? handleVerify : handleReset}>
            {error && (
              <div className="bg-error/5 text-error text-xs font-bold p-4 rounded-xl border border-error/10 flex items-center gap-2">
                <div className="w-1 h-3 bg-error rounded-full" />
                {error}
              </div>
            )}

            {viewState === 'verify' ? (
              <div className="space-y-1">
                <label className="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant ml-1">Nomor Induk Mahasiswa (NIM)</label>
                <div className="relative">
                  <Badge className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-outline-variant" />
                  <input 
                    type="text" 
                    value={nim}
                    onChange={(e) => setNim(e.target.value)}
                    placeholder="Contoh: 12045678"
                    className="w-full bg-surface-container text-on-surface rounded-2xl py-4 pl-12 pr-4 outline-none focus:ring-4 focus:ring-primary/10 transition-all font-bold"
                  />
                </div>
              </div>
            ) : (
              <div className="space-y-4">
                <div className="space-y-1">
                  <label className="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant ml-1">Password Baru</label>
                  <div className="relative">
                    <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-outline-variant" />
                    <input 
                      type="password" 
                      value={newPassword}
                      onChange={(e) => setNewPassword(e.target.value)}
                      placeholder="Minimal 6 karakter"
                      className="w-full bg-surface-container text-on-surface rounded-2xl py-4 pl-12 pr-4 outline-none focus:ring-4 focus:ring-primary/10 transition-all font-bold"
                    />
                  </div>
                </div>
                <div className="space-y-1">
                  <label className="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant ml-1">Konfirmasi Password</label>
                  <div className="relative">
                    <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-outline-variant" />
                    <input 
                      type="password" 
                      value={confirmPassword}
                      onChange={(e) => setConfirmPassword(e.target.value)}
                      placeholder="Ulangi password baru"
                      className="w-full bg-surface-container text-on-surface rounded-2xl py-4 pl-12 pr-4 outline-none focus:ring-4 focus:ring-primary/10 transition-all font-bold"
                    />
                  </div>
                </div>
              </div>
            )}

            <div className="pt-2 flex flex-col gap-3">
              <button 
                type="submit"
                disabled={isLoading}
                className="w-full bg-primary text-on-primary font-headline font-bold py-4 rounded-2xl shadow-lg shadow-primary/20 hover:opacity-90 active:scale-[0.98] disabled:opacity-50 transition-all flex items-center justify-center gap-2"
              >
                {isLoading ? <Loader2 className="w-6 h-6 animate-spin" /> : (viewState === 'verify' ? 'Verifikasi NIM' : 'Update Password')}
              </button>
              <button 
                type="button"
                onClick={onBack}
                className="w-full py-4 rounded-2xl text-primary font-headline font-bold hover:bg-surface-container transition-all"
              >
                Batal
              </button>
            </div>
          </form>
        </div>
      </div>
    </motion.main>
  );
}

/**
 * DASHBOARD VIEW
 */
function DashboardView({ user, onProfileClick, onNavigate, onLogout }: { user: StudentData, onProfileClick: () => void, onNavigate: (v: View) => void, onLogout: () => void, key?: string }) {
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [greeting, setGreeting] = useState('');

  useEffect(() => {
    const updateGreeting = () => {
      const hour = new Date().getHours();
      if (hour >= 5 && hour < 12) setGreeting('Selamat Pagi');
      else if (hour >= 12 && hour < 18) setGreeting('Selamat Siang');
      else setGreeting('Selamat Malam');
    };
    updateGreeting();
    const interval = setInterval(updateGreeting, 60000);
    return () => clearInterval(interval);
  }, []);

  const handleRefresh = () => {
    setIsRefreshing(true);
    setTimeout(() => setIsRefreshing(false), 2000);
  };

  const statusColors = {
    'Aktif': 'bg-primary border-primary',
    'Online': 'bg-blue-500 border-blue-500',
    'Libur': 'bg-amber-500 border-amber-500'
  };

  return (
    <motion.div 
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="pb-32 pt-20 bg-background min-h-screen"
    >
      {/* Sidebar Overlay */}
      <AnimatePresence>
        {isSidebarOpen && (
          <>
            <motion.div 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setIsSidebarOpen(false)}
              className="fixed inset-0 bg-black/40 backdrop-blur-sm z-[60]"
            />
            <motion.aside 
              initial={{ x: '-100%' }}
              animate={{ x: 0 }}
              exit={{ x: '-100%' }}
              transition={{ type: 'spring', damping: 25, stiffness: 200 }}
              className="fixed top-0 left-0 bottom-0 w-[80%] max-w-sm bg-surface-container-lowest z-[70] shadow-2xl p-8 flex flex-col overflow-y-auto scrollbar-hide"
            >
              <div className="flex items-center justify-between mb-10">
                <div className="flex items-center justify-between">
                  <Logo size="sm" />
                </div>
                <button onClick={() => setIsSidebarOpen(false)} className="p-2 hover:bg-surface-container rounded-full transition-colors">
                  <X className="w-6 h-6 text-outline-variant" />
                </button>
              </div>

              <nav className="flex-1 space-y-2">
                <SidebarItem 
                  icon={<LayoutGrid className="w-5 h-5" />} 
                  label="Dashboard" 
                  active 
                  onClick={() => setIsSidebarOpen(false)} 
                />
                <SidebarItem 
                  icon={<BookOpen className="w-5 h-5" />} 
                  label="Akademik" 
                  onClick={() => {
                    setIsSidebarOpen(false);
                    onNavigate('academic');
                  }} 
                />
                <SidebarItem 
                  icon={<Calendar className="w-5 h-5" />} 
                  label="Jadwal Kuliah" 
                  onClick={() => {
                    setIsSidebarOpen(false);
                    onNavigate('dashboard');
                    setTimeout(() => {
                      const el = document.getElementById('jadwal-section');
                      el?.scrollIntoView({ behavior: 'smooth' });
                    }, 100);
                  }} 
                />
                <SidebarItem 
                  icon={<TrendingUp className="w-5 h-5" />} 
                  label="Transkrip Nilai" 
                  onClick={() => {
                    setIsSidebarOpen(false);
                    onNavigate('academic');
                  }} 
                />
                <SidebarItem 
                  icon={<Bell className="w-5 h-5" />} 
                  label="Notifikasi" 
                  onClick={() => {
                    setIsSidebarOpen(false);
                    alert('Anda memiliki 3 notifikasi akademik baru.');
                  }} 
                />
                <SidebarItem 
                  icon={<Calendar className="w-5 h-5" />} 
                  label="Kalender Akademik" 
                  onClick={() => {
                    setIsSidebarOpen(false);
                    onNavigate('calendar');
                  }} 
                />
                <SidebarItem 
                  icon={<Sparkles className="w-5 h-5" />} 
                  label="Asisten AI" 
                  onClick={() => {
                    setIsSidebarOpen(false);
                    onNavigate('aiAssistant');
                  }} 
                />
              </nav>

              <div className="pt-6 border-t border-outline-variant/10">
                <button onClick={onLogout} className="w-full flex items-center gap-3 p-4 text-error font-headline font-bold hover:bg-error/5 rounded-2xl transition-all">
                  <LogOut className="w-5 h-5" />
                  Logout Sesi
                </button>
              </div>
            </motion.aside>
          </>
        )}
      </AnimatePresence>

      <header className="fixed top-0 w-full z-50 bg-surface-container-low/80 backdrop-blur-xl border-b border-outline-variant/10">
        <div className="max-w-5xl mx-auto px-6 h-16 flex items-center justify-between">
          <button 
            onClick={() => setIsSidebarOpen(true)} 
            className="w-11 h-11 flex items-center justify-center bg-surface-container-lowest border border-outline-variant/30 rounded-xl shadow-sm hover:shadow-md hover:bg-primary/5 hover:border-primary/50 active:scale-95 transition-all text-primary"
          >
            <Menu className="w-6 h-6" />
          </button>
          <Logo size="sm" />
          <div className="flex items-center gap-4">
            <button 
              onClick={() => alert('Pusat Notifikasi: \n1. KRS Disetujui\n2. Jadwal Web Dev Berubah\n3. Pembayaran UKT Berhasil')}
              className="relative w-11 h-11 flex items-center justify-center bg-surface-container-lowest border border-outline-variant/30 rounded-xl shadow-sm hover:shadow-md hover:bg-primary/5 hover:border-primary/50 active:scale-95 transition-all"
            >
              <Bell className="w-6 h-6 text-outline-variant" />
              <div className="absolute top-2.5 right-2.5 w-2 h-2 bg-error rounded-full border-2 border-surface-container-lowest" />
            </button>
            <button 
              onClick={onProfileClick}
              className="w-10 h-10 rounded-full overflow-hidden border-2 border-surface-container-lowest shadow-sm hover:scale-105 transition-transform"
            >
              <img src={user.profilePic} alt="Profile" className="w-full h-full object-cover" referrerPolicy="no-referrer" />
            </button>
          </div>
        </div>
      </header>

      <main className="max-w-5xl mx-auto px-6 space-y-10 relative">
        {/* Pull to refresh simulation */}
        <div className="flex justify-center -mt-4 mb-4">
          <button 
            onClick={handleRefresh}
            disabled={isRefreshing}
            className={`flex items-center gap-2 px-4 py-1.5 rounded-full bg-surface-container-lowest shadow-sm text-[10px] font-bold uppercase tracking-widest text-outline-variant transition-all hover:bg-surface-container active:scale-95 ${isRefreshing ? 'animate-pulse' : ''}`}
          >
            <RefreshCw className={`w-3 h-3 ${isRefreshing ? 'animate-spin' : ''}`} />
            {isRefreshing ? 'Memperbarui...' : 'Tarik untuk Segarkan'}
          </button>
        </div>

        <section className="flex flex-col md:flex-row md:items-end justify-between gap-6">
          <div className="space-y-1">
            <h2 className="font-headline text-3xl font-bold text-on-surface tracking-tight">{greeting}, {user.name.split(' ')[0]}!</h2>
            <p className="text-on-surface-variant text-lg font-medium">{user.prodi}, Semester 4</p>
          </div>
          <div className={`inline-flex items-center gap-2 bg-surface-container-lowest px-4 py-2 rounded-xl shadow-sm border-l-4 self-start ${statusColors[user.status] || 'border-primary'}`}>
            <div className={`w-2 h-2 rounded-full animate-pulse ${user.status === 'Aktif' ? 'bg-primary' : user.status === 'Online' ? 'bg-blue-500' : 'bg-amber-500'}`} />
            <span className="font-headline font-bold text-[10px] uppercase tracking-widest text-on-surface">STATUS: {user.status.toUpperCase()}</span>
          </div>
        </section>

        <section className="grid grid-cols-2 lg:grid-cols-4 gap-6">
          <DashboardStatCard label="SKS Kumulatif" value={user.sks} icon={<BookOpen className="w-5 h-5" />} color="primary" />
          <DashboardStatCard label="IPK / GPA" value={user.gpa} icon={<Award className="w-5 h-5" />} color="secondary" />
          <DashboardStatCard label="Kehadiran" value="96%" icon={<CheckCircle className="w-5 h-5" />} color="tertiary" />
          <DashboardStatCard label="Pesan Baru" value="3" icon={<Bell className="w-5 h-5" />} color="error" />
        </section>

        <section id="jadwal-section">
          <div className="flex items-center justify-between mb-6">
            <h3 className="font-headline text-xl font-bold text-on-surface flex items-center gap-3">
              <div className="w-10 h-10 bg-primary/10 rounded-xl flex items-center justify-center">
                <Calendar className="w-5 h-5 text-primary" />
              </div>
              Informasi Perkuliahan
            </h3>
            <button 
              onClick={() => alert('Jadwal perkuliahan semester ganjil 2026/2027.')}
              className="text-primary font-bold text-xs uppercase tracking-widest hover:underline flex items-center gap-1 group"
            >
              Jadwal Full
              <ChevronRight className="w-4 h-4 transition-transform group-hover:translate-x-0.5" />
            </button>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {COURSES.map(course => (
              <CourseCard 
                key={course.id} 
                day={course.day}
                time={course.time}
                title={course.title}
                code={course.code}
                room={course.room}
                lecturer={course.lecturer}
                isToday={course.isToday}
              />
            ))}
          </div>
        </section>

        <section>
          <div className="flex items-center justify-between mb-6">
            <h3 className="font-headline text-xl font-bold text-on-surface flex items-center gap-3">
              <div className="w-10 h-10 bg-primary/10 rounded-xl flex items-center justify-center">
                <Megaphone className="w-5 h-5 text-primary" />
              </div>
              Berita Kampus
            </h3>
          </div>
          <div className="space-y-4">
            {NEWS.map(news => (
              <NewsCard 
                key={news.id} 
                title={news.title}
                category={news.category}
                description={news.description}
                image={news.image}
                date={news.date}
              />
            ))}
          </div>
        </section>
      </main>

      {/* AI Floating Button */}
      <motion.button 
        whileHover={{ scale: 1.1, rotate: 5 }}
        whileTap={{ scale: 0.9 }}
        onClick={() => onNavigate('aiAssistant')}
        className="fixed bottom-32 right-6 w-16 h-16 bg-primary text-on-primary rounded-2xl shadow-[0_16px_32px_-8px_rgba(var(--primary-rgb),0.5)] z-[40] flex items-center justify-center border-2 border-white/20"
      >
        <Sparkles className="w-8 h-8" />
        <div className="absolute -top-1 -right-1 w-4 h-4 bg-error rounded-full border-2 border-primary animate-pulse" />
      </motion.button>
    </motion.div>
  );
}

function SidebarItem({ icon, label, active = false, onClick }: { icon: any, label: string, active?: boolean, onClick: () => void }) {
  return (
    <button 
      onClick={onClick}
      className={`w-full flex items-center gap-4 p-4 rounded-2xl font-headline font-bold transition-all ${active ? 'bg-primary text-on-primary shadow-lg shadow-primary/20' : 'text-on-surface-variant hover:bg-surface-container'}`}
    >
      {icon}
      <span className="tracking-wide">{label}</span>
      {active && <ChevronRight className="w-4 h-4 ml-auto" />}
    </button>
  );
}

function DashboardStatCard({ label, value, icon, color }: { label: string, value: string, icon: any, color: 'primary' | 'secondary' | 'tertiary' | 'error' }) {
  const colorMap = {
    primary: 'text-primary bg-primary/10',
    secondary: 'text-secondary bg-secondary/10',
    tertiary: 'text-tertiary bg-tertiary/10',
    error: 'text-error bg-error/10'
  };

  return (
    <motion.div 
      initial={{ opacity: 0, y: 10 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      className="bg-surface-container-lowest p-6 rounded-3xl shadow-sm border border-outline-variant/10 hover:shadow-md transition-all group"
    >
      <div className={`w-10 h-10 rounded-xl flex items-center justify-center mb-4 transition-transform group-hover:-translate-y-1 ${colorMap[color]}`}>
        {icon}
      </div>
      <p className="text-[10px] font-bold text-on-surface-variant uppercase tracking-widest mb-1 leading-none">{label}</p>
      <motion.p 
        initial={{ scale: 0.9 }}
        whileInView={{ scale: 1 }}
        className="text-3xl font-black text-on-surface"
      >
        {value}
      </motion.p>
    </motion.div>
  );
}

function NewsCard({ title, category, description, image, date }: { title: string, category: string, description: string, image: string, date: string, key?: string }) {
  return (
    <motion.article 
      initial={{ opacity: 0, x: -10 }}
      whileInView={{ opacity: 1, x: 0 }}
      viewport={{ once: true }}
      className="bg-surface-container-lowest rounded-[2.5rem] overflow-hidden shadow-sm border border-outline-variant/10 group cursor-pointer hover:shadow-md transition-all active:scale-[0.99]"
      onClick={() => alert(`Baca berita: ${title}`)}
    >
      <div className="flex flex-col md:flex-row">
        <div className="md:w-1/3 aspect-video md:aspect-auto overflow-hidden relative">
          <img src={image} alt="News" className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700" referrerPolicy="no-referrer" />
          <div className="absolute top-4 left-4 bg-primary/90 backdrop-blur-md px-3 py-1 rounded-full">
            <p className="text-[9px] font-bold text-on-primary uppercase tracking-widest">{date}</p>
          </div>
        </div>
        <div className="md:w-2/3 p-8 flex flex-col justify-center">
          <div className="flex items-center gap-2 mb-3">
            <TrendingUp className="w-3 h-3 text-primary" />
            <span className="text-[10px] font-bold text-primary uppercase tracking-widest">{category}</span>
          </div>
          <h4 className="font-headline text-2xl font-bold text-on-surface mb-3 leading-tight group-hover:text-primary transition-colors">{title}</h4>
          <p className="text-on-surface-variant text-sm line-clamp-2">{description}</p>
          <div className="mt-4 flex items-center gap-2 text-outline-variant font-bold text-[10px] uppercase tracking-widest group-hover:text-primary transition-colors">
            Selengkapnya 
            <ChevronRight className="w-3 h-3" />
          </div>
        </div>
      </div>
    </motion.article>
  );
}

function CourseCard({ day, time, title, code, room, lecturer, isToday }: { day: string, time: string, title: string, code: string, room: string, lecturer: string, isToday?: boolean, key?: string }) {
  return (
    <motion.div 
      initial={{ opacity: 0, scale: 0.95 }}
      whileInView={{ opacity: 1, scale: 1 }}
      className={`bg-surface-container-lowest rounded-[2rem] p-6 shadow-sm border transition-all group relative overflow-hidden ${isToday ? 'border-primary ring-1 ring-primary/20 bg-primary/5' : 'border-outline-variant/10 hover:border-primary/30'}`}
    >
      {isToday && (
        <div className="absolute -top-4 -right-4 bg-primary text-on-primary w-16 h-16 flex items-end justify-center pb-2 rotate-45 font-bold text-[8px] uppercase tracking-widest">
          Hari Ini
        </div>
      )}
      <div className="absolute top-0 right-0 w-24 h-24 bg-primary/5 rounded-bl-[100%] transition-transform group-hover:scale-125" />
      <div className="flex justify-between items-start mb-6">
        <div className="space-y-1">
          <span className={`text-[10px] font-bold uppercase tracking-widest px-3 py-1 rounded-full ${isToday ? 'bg-primary text-on-primary' : 'bg-surface-container text-on-surface-variant'}`}>{day}</span>
          <div className="flex items-center gap-1 text-[9px] font-bold uppercase tracking-widest text-outline-variant ml-1">
            <Clock className="w-3 h-3" />
            {time}
          </div>
        </div>
      </div>
      <h4 className="font-headline text-lg font-bold text-on-surface mb-2 leading-tight group-hover:text-primary transition-colors">{title}</h4>
      <p className="text-[10px] text-on-surface-variant font-bold uppercase tracking-widest mb-6 flex items-center gap-1">
        <MapPin className="w-3 h-3" />
        {code} • {room}
      </p>
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-2xl bg-primary-container text-on-primary-container flex items-center justify-center font-bold text-xs ring-2 ring-surface-container-lowest shadow-sm">
            {lecturer.split(' ')[1]?.charAt(0) || lecturer.charAt(0)}
          </div>
          <div className="space-y-0.5">
            <p className="text-[8px] font-bold text-outline-variant uppercase tracking-widest leading-none">Dosen Pengampu</p>
            <p className="text-xs font-bold text-on-surface">{lecturer}</p>
          </div>
        </div>
        <button className="w-8 h-8 rounded-full bg-surface-container-high flex items-center justify-center text-on-surface hover:bg-primary hover:text-on-primary transition-all">
          <ChevronRight className="w-4 h-4" />
        </button>
      </div>
    </motion.div>
  );
}

/**
 * ACADEMIC VIEW
 */
function AcademicView({ user, onBack }: { user: StudentData, onBack: () => void, key?: string }) {
  return (
    <motion.div 
      initial={{ opacity: 0, scale: 0.98 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={{ opacity: 0, scale: 1.02 }}
      className="pb-32 pt-20"
    >
      <header className="fixed top-0 w-full z-50 bg-background/80 backdrop-blur-xl border-b border-outline-variant/10">
        <div className="max-w-3xl mx-auto px-6 h-16 flex items-center">
          <button 
            onClick={onBack}
            className="w-10 h-10 flex items-center justify-center bg-surface-container-lowest border border-outline-variant/30 rounded-xl shadow-sm hover:shadow-md hover:bg-primary/5 hover:border-primary/50 active:scale-95 transition-all text-on-surface"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <h1 className="flex-1 text-center font-headline font-extrabold tracking-widest text-lg text-primary uppercase">Akademika</h1>
          <div className="w-10" />
        </div>
      </header>

      <main className="max-w-xl mx-auto px-6 space-y-8 mt-8">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="font-headline text-3xl font-bold text-on-surface tracking-tight leading-tight">Beranda Akademik</h2>
            <p className="text-on-surface-variant font-medium mt-1">Pantau progres studi dan nilai Anda.</p>
          </div>
          <div className="w-14 h-14 bg-primary/10 rounded-2xl flex items-center justify-center">
            <Award className="w-8 h-8 text-primary" />
          </div>
        </div>

        {/* Progress Card */}
        <section className="bg-primary text-on-primary rounded-[2.5rem] p-8 shadow-xl shadow-primary/20 relative overflow-hidden">
          <div className="absolute -right-10 -bottom-10 w-40 h-40 bg-white/10 rounded-full blur-3xl" />
          <div className="relative z-10">
            <div className="flex justify-between items-start mb-8">
              <div>
                <p className="text-xs font-bold uppercase tracking-widest opacity-80 mb-1">Total SKS Diskripsi</p>
                <p className="text-4xl font-black">{user.sks} <span className="text-lg font-bold opacity-60">/ 144</span></p>
              </div>
              <div className="bg-white/20 backdrop-blur-md px-4 py-2 rounded-xl">
                <p className="text-[10px] font-bold uppercase tracking-widest opacity-80">IPK Kumulatif</p>
                <p className="text-xl font-black">{user.gpa}</p>
              </div>
            </div>
            
            <div className="space-y-3">
              <div className="flex justify-between items-end">
                <p className="text-xs font-bold uppercase tracking-widest opacity-80">Target Lulus 2026</p>
                <p className="text-xs font-bold">{(parseInt(user.sks) / 144 * 100).toFixed(0)}%</p>
              </div>
              <div className="h-3 bg-white/20 rounded-full overflow-hidden">
                <motion.div 
                  initial={{ width: 0 }}
                  animate={{ width: `${parseInt(user.sks) / 144 * 100}%` }}
                  transition={{ duration: 1.5, ease: "easeOut" }}
                  className="h-full bg-white" 
                />
              </div>
            </div>
          </div>
        </section>

        {/* Semester History */}
        <section className="space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="font-headline text-lg font-bold text-on-surface">Histori Indeks Prestasi</h3>
            <span className="text-[10px] font-bold text-primary uppercase tracking-widest bg-primary/5 px-3 py-1 rounded-full">Updated: Semester 3</span>
          </div>
          
          <div className="space-y-3">
            {ACADEMIC_RECORDS.map((record, idx) => (
              <motion.div 
                key={record.semester}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: idx * 0.1 }}
                className="bg-surface-container-lowest p-5 rounded-3xl border border-outline-variant/10 shadow-sm flex items-center justify-between"
              >
                <div className="flex items-center gap-4">
                  <div className="w-10 h-10 bg-secondary-container text-on-secondary-container rounded-xl flex items-center justify-center font-black text-xs">
                    S{record.semester}
                  </div>
                  <div>
                    <h4 className="text-sm font-bold text-on-surface">Semester {record.semester}</h4>
                    <p className="text-[10px] font-medium text-on-surface-variant uppercase tracking-widest">{record.sks} SKS Terselesaikan</p>
                  </div>
                </div>
                <div className="text-right">
                  <p className="text-[10px] font-bold text-outline-variant uppercase tracking-widest leading-none mb-1">IPS (Semester)</p>
                  <p className="text-xl font-black text-primary">{record.ips}</p>
                </div>
              </motion.div>
            ))}
          </div>
        </section>

        {/* Info Card */}
        <div className="bg-surface-container rounded-3xl p-6 border border-outline-variant/5">
          <div className="flex gap-4">
            <div className="w-10 h-10 bg-surface-container-highest rounded-xl flex items-center justify-center shrink-0">
              <Megaphone className="w-5 h-5 text-on-surface-variant" />
            </div>
            <div>
              <p className="text-xs font-bold text-on-surface">Status Pengambilan KRS</p>
              <p className="text-xs text-on-surface-variant mt-1">KRS Semester 4 telah disetujui oleh Dosen Wali. Silakan cek detail mata kuliah di Dashboard.</p>
            </div>
          </div>
        </div>
      </main>
    </motion.div>
  );
}

/**
 * AI ASSISTANT VIEW
 */
function AIAssistantView({ user, courses, onBack }: { user: StudentData, courses: Course[], onBack: () => void, key?: string }) {
  const [messages, setMessages] = useState<{ role: 'ai' | 'user', content: string }[]>([
    { role: 'ai', content: `Halo ${user.name.split(' ')[0]}! Saya adalah Asisten AI Akademika. Ada yang bisa saya bantu hari ini?` }
  ]);
  const [input, setInput] = useState('');

  const suggestions = [
    "Jadwal saya hari ini?",
    "IPK saya berapa?",
    "Status KRS?",
    "Kapan UTS dimulai?"
  ];

  const handleSend = (text: string = input) => {
    if (!text.trim()) return;
    
    const newMessages = [...messages, { role: 'user', content: text } as const];
    setMessages(newMessages);
    setInput('');

    // AI Logic (Simulated)
    setTimeout(() => {
      let response = "Maaf, saya belum memahami pertanyaan itu. Bisa coba tanyakan tentang jadwal atau IPK?";
      const lowQuery = text.toLowerCase();
      
      if (lowQuery.includes('jadwal') || lowQuery.includes('hari ini')) {
        const todayCourses = courses.filter(c => c.isToday);
        if (todayCourses.length > 0) {
          response = `Jadwal kamu hari ini ada ${todayCourses.length} mata kuliah: ${todayCourses.map(c => c.title).join(', ')}. Semangat kuliahnya!`;
        } else {
          response = "Wah, sepertinya hari ini kamu tidak ada jadwal kuliah. Waktunya istirahat atau belajar mandiri!";
        }
      } else if (lowQuery.includes('ipk') || lowQuery.includes('gpa') || lowQuery.includes('nilai')) {
        response = `Nilai IPK Kumulatif kamu saat ini adalah ${user.gpa}. Keren sekali, pertahankan ya!`;
      } else if (lowQuery.includes('krs')) {
        response = "Status KRS kamu sudah DISETUJUI oleh Dosen Wali. Kamu bisa cek detailnya di menu Dashboard.";
      } else if (lowQuery.includes('uts') || lowQuery.includes('kalender')) {
        response = "Berdasarkan kalender akademik, UTS Semester Genap akan dimulai pada tanggal 15 Mei 2026. Jangan lupa belajar ya!";
      }

      setMessages(prev => [...prev, { role: 'ai', content: response }]);
    }, 600);
  };

  return (
    <motion.div 
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: 20 }}
      className="fixed inset-0 bg-background z-[100] flex flex-col"
    >
      <header className="h-20 bg-primary flex items-center px-6 gap-4 shadow-lg shrink-0">
        <button onClick={onBack} className="p-2 hover:bg-white/10 rounded-full transition-colors text-on-primary">
          <ArrowLeft className="w-6 h-6" />
        </button>
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 bg-white/20 rounded-xl flex items-center justify-center">
            <Bot className="w-6 h-6 text-on-primary" />
          </div>
          <div>
            <h2 className="font-headline font-bold text-on-primary leading-none">Akademika AI</h2>
            <div className="flex items-center gap-1.5 mt-1">
              <div className="w-1.5 h-1.5 bg-green-400 rounded-full animate-pulse" />
              <span className="text-[10px] font-bold text-on-primary/70 uppercase tracking-widest">Online</span>
            </div>
          </div>
        </div>
      </header>

      <div className="flex-1 overflow-y-auto p-6 space-y-6">
        {messages.map((m, i) => (
          <motion.div 
            key={i}
            initial={{ opacity: 0, x: m.role === 'ai' ? -10 : 10 }}
            animate={{ opacity: 1, x: 0 }}
            className={`flex ${m.role === 'ai' ? 'justify-start' : 'justify-end'}`}
          >
            <div className={`max-w-[85%] p-4 rounded-3xl font-medium text-sm leading-relaxed shadow-sm ${m.role === 'ai' ? 'bg-surface-container text-on-surface rounded-tl-sm' : 'bg-primary text-on-primary rounded-tr-sm'}`}>
              {m.content}
            </div>
          </motion.div>
        ))}
      </div>

      <div className="p-6 bg-surface-container shrink-0 space-y-4">
        <div className="flex overflow-x-auto gap-2 pb-2 no-scrollbar">
          {suggestions.map((s, i) => (
            <button 
              key={i}
              onClick={() => handleSend(s)}
              className="whitespace-nowrap px-4 py-2 bg-surface-container-highest text-on-surface-variant rounded-full text-[10px] font-bold uppercase tracking-widest border border-outline-variant/10 hover:bg-primary hover:text-on-primary transition-all shrink-0"
            >
              {s}
            </button>
          ))}
        </div>
        <div className="flex gap-3">
          <div className="flex-1 bg-surface-container-lowest rounded-2xl px-4 flex items-center border border-outline-variant/20 focus-within:ring-2 focus-within:ring-primary/20 transition-all">
            <input 
              type="text" 
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && handleSend()}
              placeholder="Tanya asisten akademik..."
              className="w-full bg-transparent border-none outline-none py-4 text-sm font-medium"
            />
          </div>
          <button 
            onClick={() => handleSend()}
            className="w-14 h-14 bg-primary text-on-primary rounded-2xl flex items-center justify-center shadow-lg active:scale-90 transition-transform"
          >
            <MessageSquare className="w-6 h-6" />
          </button>
        </div>
      </div>
    </motion.div>
  );
}

/**
 * ACADEMIC CALENDAR VIEW
 */
function AcademicCalendarView({ onBack }: { onBack: () => void, key?: string }) {
  return (
    <motion.div 
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20 }}
      className="pb-32 pt-20"
    >
      <header className="fixed top-0 w-full z-50 bg-background/80 backdrop-blur-xl border-b border-outline-variant/10">
        <div className="max-w-3xl mx-auto px-6 h-16 flex items-center">
          <button 
            onClick={onBack}
            className="w-10 h-10 flex items-center justify-center bg-surface-container-lowest border border-outline-variant/30 rounded-xl shadow-sm hover:shadow-md hover:bg-primary/5 hover:border-primary/50 active:scale-95 transition-all text-on-surface"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <h1 className="flex-1 text-center font-headline font-extrabold tracking-widest text-lg text-primary uppercase">Kalender</h1>
          <div className="w-10" />
        </div>
      </header>

      <main className="max-w-xl mx-auto px-6 space-y-8 mt-8">
        <div>
          <h2 className="font-headline text-3xl font-bold text-on-surface tracking-tight leading-tight">Kalender Akademik</h2>
          <p className="text-on-surface-variant font-medium mt-1">Semester Genap 2025/2026</p>
        </div>

        <div className="space-y-6">
          {['April', 'Mei', 'Juni'].map((month) => (
            <section key={month} className="space-y-4">
              <h3 className="font-headline text-xl font-bold text-primary flex items-center gap-3">
                <div className="w-1.5 h-6 bg-primary rounded-full" />
                {month} 2026
              </h3>
              <div className="space-y-3">
                {CALENDAR_EVENTS.filter(e => e.date.includes(month)).map((event) => (
                  <div key={event.id} className="bg-surface-container-lowest p-5 rounded-3xl border border-outline-variant/10 flex gap-5 items-center">
                    <div className="w-16 flex flex-col items-center shrink-0">
                      <p className="text-[10px] font-black uppercase text-outline-variant">{event.date.split(' ')[1]}</p>
                      <p className="text-2xl font-black text-on-surface leading-none">{event.date.split(' ')[0]}</p>
                    </div>
                    <div className="h-10 w-px bg-outline-variant/20" />
                    <div className="flex-1">
                      <p className={`text-[9px] font-bold uppercase tracking-widest mb-1 ${
                        event.type === 'holiday' ? 'text-error' : event.type === 'academic' ? 'text-primary' : 'text-blue-500'
                      }`}>
                        {event.type}
                      </p>
                      <h4 className="text-sm font-bold text-on-surface">{event.title}</h4>
                    </div>
                  </div>
                ))}
              </div>
            </section>
          ))}
        </div>
      </main>
    </motion.div>
  );
}

/**
 * PROFILE VIEW
 */
function ProfileView({ user, onUpdate, onBack }: { user: StudentData, onUpdate: (data: StudentData) => void, onBack: () => void, key?: string }) {
  const [formData, setFormData] = useState<StudentData>(user);
  const [isSaving, setIsSaving] = useState(false);
  const [saveSuccess, setSaveSuccess] = useState(false);

  const handleSave = () => {
    setIsSaving(true);
    setTimeout(() => {
      onUpdate(formData);
      setIsSaving(false);
      setSaveSuccess(true);
      setTimeout(() => setSaveSuccess(false), 3000);
    }, 1200);
  };

  return (
    <motion.div 
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20 }}
      className="pb-32 pt-20"
    >
      <header className="fixed top-0 w-full z-50 bg-background/80 backdrop-blur-xl border-b border-outline-variant/10">
        <div className="max-w-3xl mx-auto px-6 h-16 flex items-center">
          <button 
            onClick={onBack}
            className="w-10 h-10 flex items-center justify-center bg-surface-container-lowest border border-outline-variant/30 rounded-xl shadow-sm hover:shadow-md hover:bg-primary/5 hover:border-primary/50 active:scale-95 transition-all text-on-surface"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <h1 className="flex-1 text-center font-headline font-extrabold tracking-widest text-lg text-primary uppercase">Akademika</h1>
          <div className="w-10" />
        </div>
      </header>

      <main className="max-w-xl mx-auto px-6 space-y-10 mt-8">
        <div>
          <h2 className="font-headline text-3xl font-bold text-on-surface tracking-tight leading-tight">Profil Mahasiswa</h2>
          <p className="text-on-surface-variant font-medium mt-1">Kelola data direktori kampus Anda.</p>
        </div>

        <div className="flex flex-col items-center">
          <div className="relative group">
            <div className="w-32 h-32 rounded-full overflow-hidden border-4 border-surface-container-lowest shadow-2xl relative">
              <img src={formData.profilePic} alt="Profile" className="w-full h-full object-cover transition-transform group-hover:scale-105" referrerPolicy="no-referrer" />
              <div className="absolute inset-0 bg-black/20 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                <Camera className="text-white w-8 h-8" />
              </div>
            </div>
            <button 
              className="absolute bottom-1 right-1 w-10 h-10 rounded-full bg-primary text-on-primary flex items-center justify-center shadow-lg border-2 border-surface-container-lowest hover:scale-110 active:scale-95 transition-all"
              onClick={() => {
                const newPic = `https://picsum.photos/seed/student_${Math.random()}/400/400`;
                setFormData({ ...formData, profilePic: newPic });
              }}
            >
              <Camera className="w-5 h-5" />
            </button>
          </div>
        </div>

        <div className="bg-surface-container-lowest rounded-[2.5rem] p-8 shadow-[0_32px_64px_-16px_rgba(44,51,57,0.08)] border border-outline-variant/10 space-y-6">
          {saveSuccess && (
            <motion.div 
              initial={{ opacity: 0, y: -10 }} animate={{ opacity: 1, y: 0 }}
              className="bg-primary/10 text-primary p-3 rounded-xl flex items-center gap-3 border border-primary/20"
            >
              <CheckCircle className="w-5 h-5 fill-current" />
              <span className="text-sm font-bold">Data berhasil diperbarui!</span>
            </motion.div>
          )}

          <div className="space-y-4">
            <ProfileField 
              label="NIM (Student ID)" 
              value={formData.nim} 
              icon={<Badge className="w-4 h-4" />} 
              readOnly 
              helpText="Kontak akademik jika ada kesalahan NIM." 
            />
            <ProfileField 
              label="Nama Lengkap" 
              value={formData.name} 
              icon={<UserIcon className="w-4 h-4" />} 
              onChange={(v) => setFormData({ ...formData, name: v })}
            />
            <ProfileField 
              label="Program Studi" 
              value={formData.prodi} 
              icon={<Badge className="w-4 h-4" />} 
              type="select"
              options={['Information Systems', 'Computer Science', 'Data Science', 'Informatika']}
              onChange={(v) => setFormData({ ...formData, prodi: v })}
            />
            <div className="grid grid-cols-2 gap-4">
              <ProfileField 
                label="Kelas" 
                value={formData.class} 
                type="select"
                options={['A', 'B', 'C', 'D']}
                onChange={(v) => setFormData({ ...formData, class: v })}
              />
              <ProfileField 
                label="Tahun Masuk" 
                value={formData.year} 
                type="select"
                options={['2021', '2022', '2023', '2024']}
                onChange={(v) => setFormData({ ...formData, year: v })}
              />
            </div>
          </div>
        </div>

        <div className="flex flex-col gap-3 pb-8">
          <button 
            onClick={handleSave}
            disabled={isSaving}
            className="w-full py-4 rounded-2xl bg-primary text-on-primary font-headline font-bold text-lg shadow-lg shadow-primary/20 hover:opacity-90 active:scale-[0.98] disabled:opacity-50 transition-all flex items-center justify-center gap-2"
          >
            {isSaving ? <Loader2 className="w-6 h-6 animate-spin" /> : (
              <>
                <Save className="w-5 h-5" />
                Simpan Perubahan
              </>
            )}
          </button>
          <button onClick={onBack} className="w-full py-4 rounded-2xl text-primary font-headline font-bold text-lg hover:bg-surface-container transition-all">
            Batal
          </button>
        </div>
      </main>
    </motion.div>
  );
}

function ProfileField({ label, value, icon, readOnly, helpText, type = 'text', options, onChange }: any) {
  return (
    <div className="space-y-1.5">
      <label className="text-[10px] font-bold uppercase tracking-widest text-on-surface-variant ml-2 leading-none">{label}</label>
      <div className={`flex items-center gap-3 bg-surface-container rounded-2xl px-4 py-3.5 focus-within:bg-surface-container-lowest focus-within:ring-4 focus-within:ring-primary/5 transition-all ${readOnly ? 'opacity-80 grayscale' : ''}`}>
        {icon && <div className="text-outline-variant">{icon}</div>}
        {type === 'text' ? (
          <input 
            type="text" 
            value={value} 
            readOnly={readOnly}
            onChange={(e) => onChange?.(e.target.value)}
            className="w-full bg-transparent border-none outline-none font-sans text-sm font-bold text-on-surface p-0 focus:ring-0"
          />
        ) : (
          <div className="relative w-full">
            <select 
              value={value}
              onChange={(e) => onChange?.(e.target.value)}
              className="w-full bg-transparent border-none outline-none font-sans text-sm font-bold text-on-surface p-0 pr-8 focus:ring-0 appearance-none cursor-pointer"
            >
              {options?.map((opt: string) => <option key={opt} value={opt}>{opt}</option>)}
            </select>
            <ChevronDown className="absolute right-0 top-1/2 -translate-y-1/2 w-5 h-5 text-outline-variant pointer-events-none" />
          </div>
        )}
      </div>
      {helpText && <p className="text-[9px] font-bold text-outline-variant/60 ml-2 tracking-wide font-headline">{helpText}</p>}
    </div>
  );
}

/**
 * SHARED COMPONENTS
 */
function Logo({ size = 'md', className = '', stack = false }: { size?: 'sm' | 'md' | 'lg', className?: string, stack?: boolean }) {
  const sizeMap = {
    sm: { container: 'h-8', icon: 'w-5 h-5', text: 'text-lg', iconBox: 'w-8 h-8' },
    md: { container: 'h-10', icon: 'w-6 h-6', text: 'text-xl', iconBox: 'w-10 h-10' },
    lg: { container: 'h-24', icon: 'w-10 h-10', text: 'text-4xl', iconBox: 'w-16 h-16' }
  };

  const current = sizeMap[size];

  return (
    <div className={`flex ${stack ? 'flex-col' : 'flex-row'} items-center gap-3 ${className}`}>
      <div className={`relative group`}>
        <div className={`absolute inset-0 bg-primary/40 rounded-2xl blur-xl group-hover:bg-primary/60 transition-all duration-500`} />
        <div className={`${current.iconBox} bg-gradient-to-br from-primary via-primary to-primary-container rounded-2xl flex items-center justify-center relative z-10 shadow-lg shadow-primary/20 border border-white/20 transform transition-transform duration-500 group-hover:rotate-6 group-hover:scale-110`}>
          <School className={`${current.icon} text-on-primary fill-current`} />
          <div className="absolute top-0 right-0 w-full h-full bg-gradient-to-tr from-white/0 via-white/5 to-white/20 rounded-2xl pointer-events-none" />
        </div>
      </div>
      <div className={`flex flex-col ${stack ? 'items-center mt-2' : 'items-start'}`}>
        <h1 className={`font-headline font-black tracking-tight text-on-surface leading-none ${current.text}`}>
          Akademika
          <span className="text-primary">.</span>
        </h1>
        <div className={`h-1 bg-gradient-to-r from-primary to-transparent rounded-full mt-1 ${size === 'lg' ? 'w-24' : 'w-12 opacity-0'}`} />
      </div>
    </div>
  );
}

function BottomNavBar({ activeView, onViewChange }: { activeView: View, onViewChange: (v: View) => void }) {
  return (
    <nav className="fixed bottom-8 left-1/2 -translate-x-1/2 w-[92%] max-w-md bg-surface-container-low/95 backdrop-blur-xl border border-white/20 rounded-[2.5rem] shadow-[0_32px_64px_-16px_rgba(0,0,0,0.15)] z-50">
      <div className="flex justify-around items-center h-20 px-4">
        <NavButton active={activeView === 'dashboard'} onClick={() => onViewChange('dashboard')} label="Beranda" icon={<LayoutGrid className="w-5 h-5" />} />
        <NavButton active={activeView === 'academic'} onClick={() => onViewChange('academic')} label="Akademik" icon={<BookOpen className="w-5 h-5" />} />
        <NavButton active={activeView === 'profile'} onClick={() => onViewChange('profile')} label="Profil" icon={<UserIcon className="w-5 h-5" />} />
      </div>
    </nav>
  );
}

function NavButton({ active, label, icon, onClick }: { active: boolean, label: string, icon: any, onClick: () => void }) {
  return (
    <button 
      onClick={onClick}
      className={`flex flex-col items-center justify-center rounded-[1.5rem] transition-all duration-500 px-6 py-2.5 ${active ? 'bg-primary text-on-primary shadow-xl shadow-primary/25 scale-105' : 'text-on-surface-variant hover:bg-surface-container-high'}`}
    >
      <div className={`transition-all ${active ? 'scale-110' : 'group-hover:scale-110'}`}>{icon}</div>
      <span className={`text-[10px] font-bold uppercase tracking-widest mt-1.5 ${active ? 'opacity-100' : 'opacity-60'}`}>{label}</span>
    </button>
  );
}


