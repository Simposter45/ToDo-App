class UserModel {
  String uid;
  String name;
  String email;
  String password;
  String createdAt;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
    required this.uid,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      createdAt: map['createdAt'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'createdAt': createdAt,
      'uid': uid,
    };
  }
}
