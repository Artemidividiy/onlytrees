import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/auth/view.dart';

class UserRepository {
  User data;
  UserRepository({
    required this.data,
  });

  UserRepository copyWith({
    User? data,
  }) {
    return UserRepository(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.toMap(),
    };
  }

  static Future<UserRepository> fromStorage() async {
    return UserRepository(data: await User.fromStorage());
  }

  factory UserRepository.fromMap(Map<String, dynamic> map) {
    return UserRepository(
      data: User.fromMap(map),
    );
  }
  factory UserRepository.empty() => UserRepository(data: User.empty());
  String toJson() => json.encode(toMap());

  factory UserRepository.fromJson(String source) =>
      UserRepository.fromMap(json.decode(source));

  @override
  String toString() => 'UserRepository(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserRepository && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
  Future<void> delete() async {
    await SharedPreferences.getInstance()
      ..clear();
  }
}

@immutable
class User {
  final String id;
  final String username;
  final String password;
  final int age;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.age,
  });
  factory User.empty() =>
      User(username: "unknown", age: -1, id: 'unknown', password: 'unknown');
  User copyWith({
    String? id,
    String? username,
    String? password,
    int? age,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'age': age,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      age: map['age']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
  static Future<User> fromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    int age = prefs.getInt('age') ?? -1;
    String username = prefs.getString("username") ?? "unknown";
    String id = prefs.getString("id") ?? "unknown";
    String password = prefs.getString("password") ?? 'unknown';
    return User(id: id, username: username, age: age, password: password);
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, password: $password, age: $age)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.username == username &&
        other.password == password &&
        other.age == age;
  }

  @override
  int get hashCode {
    return id.hashCode ^ username.hashCode ^ password.hashCode ^ age.hashCode;
  }
}

class UserNotifier extends StateNotifier<UserRepository> {
  UserNotifier(super.state) {
    UserRepository.fromStorage().then((value) => state = value);
  }

  Future<void> getUser() async {
    state = await UserRepository.fromStorage();
  }

  Future<void> update({required UserRepository updated}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", updated.data.username);
    await prefs.setString("id", updated.data.id);
    await prefs.setInt("age", updated.data.age);
    await prefs.setString("password", updated.data.password);
    state = updated;
  }

  Future<void> logout(BuildContext context) async {
    state = UserRepository.empty();

    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, a1, a2) => AuthView(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ));
  }

  UserRepository get data => state;
}

final userProvider = StateNotifierProvider<UserNotifier, UserRepository>(
    (ref) => UserNotifier(UserRepository.empty()));
