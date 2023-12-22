import 'package:it_del/Models/user.dart';

class RequestIzinSurat {
  int? id;
  User? user;
  int? approverId;
  String? reason;
  String? alamat;
  String? status;

  RequestIzinSurat({
    this.id,
    this.user,
    this.approverId,
    this.reason,
    this.alamat,
    this.status,
  });

  factory RequestIzinSurat.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return RequestIzinSurat();
    }

    return RequestIzinSurat(
      id: json['id'] as int?,
      approverId: json['approver_id'] as int?,
      reason: json['reason'] as String?,
      alamat: json['alamat'] as String?,
      status: json['status'] as String?,
      user: json['user'] != null
          ? User(id: json['user']['id'], name: json['user']['name'])
          : null,
    );
  }
}
