class BookingBaju {
  final int id;
  final int userId;
  final int bajuId;
  final String ukuranBaju;
  final String metodePembayaran;
  final String tanggalPengambilan;
  final String status;

  BookingBaju({
    required this.id,
    required this.userId,
    required this.bajuId,
    required this.ukuranBaju,
    required this.metodePembayaran,
    required this.tanggalPengambilan,
    required this.status,
  });

  factory BookingBaju.fromJson(Map<String, dynamic> json) {
    return BookingBaju(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      bajuId: json['baju_id'] ?? 0,
      ukuranBaju: json['ukuran_baju'] ?? '',
      metodePembayaran: json['metode_pembayaran'] ?? '',
      tanggalPengambilan: json['tanggal_pengambilan'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
