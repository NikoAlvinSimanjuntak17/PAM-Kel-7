class BookingBajuBaak {
  final int id;
  int? userId;
  int? bajuId;
  String? ukuranBaju;
  String? metodePembayaran;
  String? tanggalPengambilan;
  String? status;

  BookingBajuBaak({
    required this.id,
    this.userId,
    this.bajuId,
    this.ukuranBaju,
    this.metodePembayaran,
    this.tanggalPengambilan,
    this.status,
  });

  factory BookingBajuBaak.fromJson(Map<String, dynamic> json) {
    return BookingBajuBaak(
      id: json['id'] as int,
      userId: json['user_id'],
      bajuId: json['baju_id'],
      ukuranBaju: json['ukuran_baju'],
      metodePembayaran: json['metode_pembayaran'],
      tanggalPengambilan: json['tanggal_pengambilan'],
      status: json['status'],
    );
  }
}
