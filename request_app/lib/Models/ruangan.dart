class Ruangan {
  int? id;
  String? NamaRuangan;

  Ruangan({
    this.id,
    this.NamaRuangan,
  });

  factory Ruangan.fromJson(Map<String, dynamic> json) {
    return Ruangan(
      id: json['id'] as int?,
      NamaRuangan: json['NamaRuangan'] as String?,
    );
  }
}
