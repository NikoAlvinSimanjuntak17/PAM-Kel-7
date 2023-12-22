class BookingRuanganBaak {
  final int id;
  final String reason;
  final int userId;
  final int roomId;
  final String status;
  final String startTime;
  final String endTime;

  BookingRuanganBaak({
    required this.id,
    required this.reason,
    required this.userId,
    required this.roomId,
    required this.status,
    required this.startTime,
    required this.endTime,
  });

  factory BookingRuanganBaak.fromJson(Map<String, dynamic> json) {
    return BookingRuanganBaak(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      reason: json['reason'] as String,
      roomId: json['room_id'] as int,
      status: json['status'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
    );
  }
}
