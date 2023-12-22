class IzinSuratBaak {
  final int id;
  final int userId;
  final String status;
  final String reason;
  final String alamat;

  IzinSuratBaak({
    required this.id,
    required this.userId,
    required this.status,
    required this.reason,
    required this.alamat,
  });

  factory IzinSuratBaak.fromJson(Map<String, dynamic> json) {
    return IzinSuratBaak(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      status: json['status'] as String,
      reason: json['reason'] as String,
      alamat: json['alamat'] as String,
    );
  }
}
