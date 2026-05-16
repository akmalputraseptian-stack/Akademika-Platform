class Krs {
  final int? id;
  final String kodeMatkul;
  final String namaMatkul;
  final int sks;
  final String semester;
  final String? nilai;

  Krs({
    this.id,
    required this.kodeMatkul,
    required this.namaMatkul,
    required this.sks,
    required this.semester,
    this.nilai,
  });

  factory Krs.fromJson(Map<String, dynamic> json) {
    return Krs(
      id: json['id'],
      kodeMatkul: json['kode_matkul'],
      namaMatkul: json['nama_matkul'],
      sks: json['sks'],
      semester: json['semester'],
      nilai: json['nilai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode_matkul': kodeMatkul,
      'nama_matkul': namaMatkul,
      'sks': sks,
      'semester': semester,
      'nilai': nilai,
    };
  }
}
