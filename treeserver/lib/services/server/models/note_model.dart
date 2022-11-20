import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:riverpod/riverpod.dart';
import 'package:treeserver/services/server/models/note_domain.dart';

import 'package:treeserver/services/server/models/user_model.dart';

import '../enums/note_type.dart';

@HiveType(typeId: 1)
class Note extends HiveObject {
  @HiveField(0)
  String? textData;
  @HiveField(1)
  User author;
  @HiveField(2)
  DateTime createdAt;
  @HiveField(3)
  String arDataPath;

  @HiveField(4)
  NoteType type;

  Note({
    this.textData,
    required this.author,
    required this.createdAt,
    required this.arDataPath,
    required this.type,
  });

  Note copyWith({
    String? textData,
    User? author,
    DateTime? createdAt,
    String? arDataPath,
    NoteType? type,
  }) {
    return Note(
      textData: textData ?? this.textData,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      arDataPath: arDataPath ?? this.arDataPath,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'textData': textData,
      'author': author.toMap(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'arDataPath': arDataPath,
      'type': type.toString()
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
        textData: map['textData'],
        author: User.fromMap({
          "username": map['author']['username'],
          'password': map['author']['password'],
          'age': map['author']['age']
        }),
        createdAt: DateTime.now(),
        arDataPath: map['arDataPath'] ?? '',
        type: map['type'] == "String" ? NoteType.String : NoteType.AR);
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(textData: $textData, author: $author, createdAt: $createdAt, arDataPath: $arDataPath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.textData == textData &&
        other.author == author &&
        other.createdAt == createdAt &&
        other.arDataPath == arDataPath &&
        other.type == type;
  }

  @override
  int get hashCode {
    return textData.hashCode ^
        author.hashCode ^
        createdAt.hashCode ^
        arDataPath.hashCode ^
        type.hashCode;
  }
}
