import 'package:it_del/Models/user.dart';

class RequestIzinKeluar {
  int? id;
  User? user;
  int? approverId;
  String? reason;
  DateTime? startDate;
  DateTime? endDate;
  String? status;

  RequestIzinKeluar({
    this.id,
    this.user,
    this.approverId,
    this.reason,
    this.startDate,
    this.endDate,
    this.status,
  });

  factory RequestIzinKeluar.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return RequestIzinKeluar();
    }

    return RequestIzinKeluar(
      id: json['id'] as int?,
      approverId: json['approver_id'] as int?,
      reason: json['reason'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      status: json['status'] as String?,
      user: json['user'] != null
          ? User(id: json['user']['id'], name: json['user']['name'])
          : null,
    );
  }
}
