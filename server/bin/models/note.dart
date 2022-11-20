import 'dart:convert';

import 'user.dart';

class Note<T> {
  T data;
  User author;
  Note({
    required this.data,
    required this.author,
  });

  Note<T> copyWith({
    T? data,
    User? author,
  }) {
    return Note<T>(
      data: data ?? this.data,
      author: author ?? this.author,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.toString(),
      'author': author.toMap(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note<T>(
      data: map['data'],
      author: User.fromMap(map['author']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() => 'Note(data: $data, author: $author)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note<T> && other.data == data && other.author == author;
  }

  @override
  int get hashCode => data.hashCode ^ author.hashCode;
}
