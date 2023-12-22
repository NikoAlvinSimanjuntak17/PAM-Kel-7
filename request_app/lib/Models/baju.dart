class Baju {
  int? id;
  String? harga;
  String? ukuran;

  Baju({
    this.harga,
    this.id,
    this.ukuran,
  });

  factory Baju.fromJson(Map<String, dynamic> json) {
    return Baju(
      id: json['id'] as int?, // Default value (0 in this case) if null
      harga: json['harga'] as String?, // Default value (empty string) if null
      ukuran: json['ukuran'] as String?, // Default value (empty string) if null
    );
  }
}
