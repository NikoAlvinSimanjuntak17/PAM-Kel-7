class User {
  int? id;
  String? name;
  String? nomor_ktp;
  String? nim;
  String? role;
  String? nomor_handphone;
  String? email;
  String? password;
  String? token;

  User({
    this.id,
    this.name,
    this.nomor_ktp,
    this.nim,
    this.role,
    this.nomor_handphone,
    this.email,
    this.password,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      name: json['user']['name'],
      nomor_ktp: json['user']['nomor_ktp'],
      nim: json['user']['nim'],
      role: json['user']['role'],
      nomor_handphone: json['user']['nomor_handphone'],
      email: json['user']['email'],
      password: json['user']['password'],
      token: json['token'],
    );
  }
}
