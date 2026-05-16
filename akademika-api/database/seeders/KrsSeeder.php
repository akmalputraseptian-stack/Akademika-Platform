<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Krs;
use App\Models\Mahasiswa;

class KrsSeeder extends Seeder
{
    public function run(): void
    {
        // Ambil mahasiswa TERAKHIR (yang baru saja didaftarkan user)
        $mahasiswa = Mahasiswa::latest()->first();
        if (!$mahasiswa) return;

        $kurikulum = [
            // Semester 1
            ['semester' => '1', 'data' => [
                ['08080', 'Fisika', 2],
                ['08006', 'Pengantar Teknik Komputer', 2],
                ['00001', 'Agama', 2],
                ['00006', 'Hardware Komputer', 3],
                ['08112', 'Algoritma dan Pemograman', 2],
                ['08114', 'Matematika', 3],
                ['00004', 'Bahasa Inggris I', 2],
                ['08113', 'Aplikasi Komputer Dasar', 2],
            ]],
            // Semester 2
            ['semester' => '2', 'data' => [
                ['08115', 'Elektronika I', 2],
                ['08031', 'Rangkaian Digital', 3],
                ['08029', 'Sistem Operasi', 2],
                ['08011', 'Pengantar Telekomunikasi', 2],
                ['08116', 'Pemograman Web', 4],
                ['08117', 'Sistem Basis Data', 2],
                ['00003', 'Pancasila dan Kewarganegaraan', 3],
                ['08069', 'Bahasa Inggris II', 2],
            ]],
            // Semester 3
            ['semester' => '3', 'data' => [
                ['08118', 'Elektronika II', 2],
                ['08119', 'Mikrokontroler I', 2],
                ['00002', 'Bahasa Indonesia', 2],
                ['08073', 'Organisasi dan Arsitektur Komputer', 3],
                ['08038', 'Komunikasi Data', 2],
                ['08121', 'Etika Profesi', 2],
                ['00003', 'Teknik Presentasi dan Pelaporan', 3],
                ['08023', 'Pemograman Berorientasi Objek', 2],
            ]],
            // Semester 4
            ['semester' => '4', 'data' => [
                ['08123', 'Mikrokontroller II', 2],
                ['08124', 'Antarmuka Komputer dan Peripheral', 2],
                ['08096', 'Jaringan Komputer', 2],
                ['08125', 'Routing & Switching I', 2],
                ['08142', 'Pemrograman Mobile', 2],
                ['08127', 'Teknologi IoT', 2],
                ['08128', 'Pemagangan Industri', 2],
                ['00005', 'Kewirausahaan', 3],
                ['08130', 'Olahraga', 2],
            ]],
            // Semester 5
            ['semester' => '5', 'data' => [
                ['08131', 'Kontrol Cerdas', 2],
                ['08132', 'Manajemen Jaringan', 3],
                ['08133', 'Komunikasi dan Keorganisasian', 3],
                ['08134', 'Routing & Switching II', 2],
                ['08135', 'Pengembangan Profesionalisme', 3],
                ['08107', 'Kapita Selekta', 3],
            ]],
            // Semester 6
            ['semester' => '6', 'data' => [
                ['08137', 'Proyek Akhir', 6],
                ['08138', 'Interaksi Manusia dan Komputer', 3],
                ['00007', 'Animasi dan Multimedia', 3],
                ['08140', 'Administrasi Sistem Server', 2],
                ['08141', 'Toefl Preparation', 2],
            ]],
        ];

        foreach ($kurikulum as $sem) {
            foreach ($sem['data'] as $mk) {
                Krs::updateOrCreate(
                    [
                        'mahasiswa_id' => $mahasiswa->id,
                        'kode_matkul' => $mk[0]
                    ],
                    [
                        'nama_matkul' => $mk[1],
                        'sks' => $mk[2],
                        'semester' => 'Semester ' . $sem['semester'],
                    ]
                );
            }
        }
    }
}
