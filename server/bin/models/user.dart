import 'dart:convert';

class User {
  String username;
  int age;
  String contact;
  int notesCount;
  User({
    required this.username,
    required this.age,
    required this.contact,
    required this.notesCount,
  });

  User copyWith({
    String? username,
    int? age,
    String? contact,
    int? notesCount,
  }) {
    return User(
      username: username ?? this.username,
      age: age ?? this.age,
      contact: contact ?? this.contact,
      notesCount: notesCount ?? this.notesCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'age': age,
      'contact': contact,
      'notesCount': notesCount,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? '',
      age: map['age']?.toInt() ?? 0,
      contact: map['contact'] ?? '',
      notesCount: map['notesCount']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(username: $username, age: $age, contact: $contact, notesCount: $notesCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.username == username &&
        other.age == age &&
        other.contact == contact &&
        other.notesCount == notesCount;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        age.hashCode ^
        contact.hashCode ^
        notesCount.hashCode;
  }
}
