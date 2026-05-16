class Mahasiswa {
  final int? id;
  final String nim;
  final String nama;
  final String jurusan;
  final String angkatan;
  final String email;
  final String? status;
  final String? gpa;
  final String? sks;
  final String? profilePic;
  final String? className;

  Mahasiswa({
    this.id,
    required this.nim,
    required this.nama,
    required this.jurusan,
    required this.angkatan,
    required this.email,
    this.status,
    this.gpa,
    this.sks,
    this.profilePic,
    this.className,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      id: json['id'],
      nim: json['nim'] ?? '',
      nama: json['nama'] ?? '',
      jurusan: json['jurusan'] ?? '',
      angkatan: json['angkatan'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? 'Aktif',
      gpa: json['gpa']?.toString() ?? '0.00',
      sks: json['sks']?.toString() ?? '0',
      profilePic: json['profilePic'] ?? '',
      className: json['class'] ?? 'A',
    );
  }

  Map<String, dynamic> toJson() => {
    'nim': nim,
    'nama': nama,
    'jurusan': jurusan,
    'angkatan': angkatan,
    'email': email,
    'status': status,
    'gpa': gpa,
    'sks': sks,
    'profilePic': profilePic,
    'class': className,
  };

  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
    return Mahasiswa(
      nim: map['nim'],
      nama: map['nama'],
      jurusan: map['jurusan'] ?? '',
      angkatan: map['angkatan'] ?? '',
      email: map['email'] ?? '',
      status: map['status'] ?? 'Aktif',
      gpa: map['gpa'] ?? '0.00',
      sks: map['sks'] ?? '0',
      profilePic: map['profilePic'] ?? '',
      className: map['className'] ?? 'A',
    );
  }

  Map<String, dynamic> toMap() => {
    'nim': nim,
    'nama': nama,
    'jurusan': jurusan,
    'angkatan': angkatan,
    'status': status,
    'gpa': gpa,
    'sks': sks,
    'profilePic': profilePic,
  };
}

class Course {
  final String id, day, time, title, code, room, lecturer;
  final bool isToday;
  Course({required this.id, required this.day, required this.time, required this.title, required this.code, required this.room, required this.lecturer, this.isToday = false});
}

class News {
  final String id, title, category, description, image, date;
  News({required this.id, required this.title, required this.category, required this.description, required this.image, required this.date});
}
