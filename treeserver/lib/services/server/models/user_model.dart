import 'dart:convert';

import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  String username;
  @HiveField(1)
  String password;
  @HiveField(2)
  int age;
  User({
    required this.username,
    required this.password,
    required this.age,
  });

  User copyWith({
    String? username,
    String? password,
    int? age,
  }) {
    return User(
      username: username ?? this.username,
      password: password ?? this.password,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'age': age,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      age: map['age']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() =>
      'User(username: $username, password: $password, age: $age)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.username == username &&
        other.password == password &&
        other.age == age;
  }

  @override
  int get hashCode => username.hashCode ^ password.hashCode ^ age.hashCode;
}
