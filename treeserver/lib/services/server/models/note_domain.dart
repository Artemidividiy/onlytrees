import 'dart:convert';
import 'dart:developer';

import 'package:shelf/shelf.dart';
import 'package:treeserver/services/initializer/hive_initializer.dart';

import '../../../app/enums/message_type.dart';
import '../../../app/logger/model.dart';
import 'note_model.dart';

class NoteDomain {
  static Future<List<Note>> getAllWithoutRequest() async {
    List<Note> target = [];
    var data = (await HiveWorker.notes.getAll(
      await HiveWorker.notes.getAllKeys(),
    ));
    for (var element in data) {
      target.add(Note.fromMap({
        'textData': element['textData'],
        'author': element['author'],
        'createdAt': element['createdAt'],
        'arDataPath': element['arDataPath'],
        'type': element['type']
      }));
    }
    await LoggerDomain.add(Message(
        data: "getAllWithoutRequest",
        type: MessageType.note,
        time: DateTime.now()));
    return target;
  }

  static Future<Response> getAll(Request req) async {
    try {
      print((await HiveWorker.notes.getAll(
        await HiveWorker.notes.getAllKeys(),
      )));
      var notes = (await HiveWorker.notes.getAll(
        await HiveWorker.notes.getAllKeys(),
      ));
      await LoggerDomain.add(Message(
          data: "getAll Error", type: MessageType.note, time: DateTime.now()));
      Response target = Response.ok(json.encode(notes));
      return target;
    } catch (e) {
      log(e.toString());
      await LoggerDomain.add(Message(
          data: "getAll Error", type: MessageType.note, time: DateTime.now()));
      return Response.internalServerError();
    }
  }

  static Future<Response> post(Request req) async {
    try {
      var data = json.decode(await req.readAsString());
      Note note = Note.fromMap(data);
      HiveWorker.notes.put(
          (await HiveWorker.notes.getAllKeys()).length.toString(),
          note.toMap());
      await LoggerDomain.add(
          Message(data: "post", type: MessageType.note, time: DateTime.now()));
      return Response.ok("posted");
    } catch (e) {
      log(e.toString());
      await LoggerDomain.add(Message(
          data: "post ERROR", type: MessageType.note, time: DateTime.now()));
      return Response.internalServerError();
    }
  }

  static Future<Response> getOne(Request req) async {
    try {
      var query = await req.readAsString();
      var queryParams = json.decode(query);
      await LoggerDomain.add(Message(
          data: "getOne ", type: MessageType.note, time: DateTime.now()));
      return Response.ok(
          ((await HiveWorker.notes.get(queryParams['id'])) as List<Map>)
              .first
              .values
              .first);
    } catch (e) {
      log(e.toString());
      await LoggerDomain.add(Message(
          data: "getOne Error", type: MessageType.note, time: DateTime.now()));
      return Response.internalServerError();
    }
  }
}
