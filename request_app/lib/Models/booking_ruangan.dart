import 'package:it_del/Models/user.dart';

// models/booking_ruangan.dart

class BookingRuangan {
  int? id;
  String? reason;
  User? user;
  int? approverId;
  int? roomId;
  String? status;
  DateTime? startTime;
  DateTime? endTime;

  BookingRuangan({
    required this.id,
    required this.reason,
    required this.user,
    required this.approverId,
    required this.roomId,
    required this.status,
    required this.startTime,
    required this.endTime,
  });

  factory BookingRuangan.fromJson(Map<String, dynamic> json) {
    return BookingRuangan(
      id: json['id'] as int?,
      reason: json['reason'] as String?,
      approverId: json['approver_id'] as int?,
      roomId: json['room_id'] as int?,
      status: json['status'] as String?,
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      user: json['user'] != null
          ? User(id: json['user']['id'], name: json['user']['name'])
          : null,
    );
  }
}
