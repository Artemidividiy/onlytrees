import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:treeusers/enums/notetype.dart';
import 'package:treeusers/modules/home/view.dart';
import 'package:treeusers/repositories/user.dart';
import 'package:treeusers/utils/connect.dart';

class Note {
  String id;
  NoteType type;
  UserRepository author;
  String? textData;
  File? arData;
  DateTime createdAt;
  Note(
      {required this.id,
      required this.author,
      this.textData,
      this.arData,
      required this.createdAt,
      this.type = NoteType.String})
      : assert((textData == null && arData != null) ||
            (type == NoteType.String && textData != null) ||
            (type == NoteType.AR && arData != null));

  Note copyWith(
      {String? id,
      UserRepository? author,
      String? textData,
      File? arData,
      NoteType? type,
      DateTime? createdAt}) {
    return Note(
        type: type ?? this.type,
        id: id ?? this.id,
        author: author ?? this.author,
        textData: textData ?? this.textData,
        arData: arData ?? this.arData,
        createdAt: createdAt ?? this.createdAt);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author.toMap(),
      'textData': textData,
      'arData': arData?.path.toString(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        type: map['textData'] != null ? NoteType.String : NoteType.AR,
        id: map['id'] ?? '',
        author: UserRepository.fromMap(map['author']),
        textData: map['textData'],
        arData: map['arData'] != null ? map['arData'] : null);
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, author: $author, textData: $textData, arData: $arData)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.id == id &&
        other.author == author &&
        other.textData == textData &&
        other.arData == arData;
  }

  @override
  int get hashCode {
    return id.hashCode ^ author.hashCode ^ textData.hashCode ^ arData.hashCode;
  }

  factory Note.empty() => Note(
      createdAt: DateTime.now(),
      id: "id",
      author: UserRepository.empty(),
      type: NoteType.String,
      textData: "empty");
}

class NoteRepository {
  List<Note> data;
  NoteRepository({
    required this.data,
  });

  NoteRepository copyWith({
    List<Note>? data,
  }) {
    return NoteRepository(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory NoteRepository.fromMap(Map<String, dynamic> map) {
    return NoteRepository(
      data: List<Note>.from(map['data']?.map((x) => Note.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteRepository.fromJson(String source) =>
      NoteRepository.fromMap({"data": json.decode(source)});

  @override
  String toString() => 'NoteRepository(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoteRepository && listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;

  factory NoteRepository.empty() => NoteRepository(data: []);

  static Future<NoteRepository> get() async {
    http.Response res =
        await http.get(Uri.parse("${Connect.serverAdress!}/notes"));
    return NoteRepository.fromJson(res.body);
  }

  Future<void> push(BuildContext context, Note note) async {
    try {
      var res = await http.post(Uri.parse(Connect.serverAdress! + "/notes"),
          headers: {
            "content-type": "application/json",
          },
          body: note.toJson());
      if (res.statusCode == 200) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeView()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("something went wrong")));
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
