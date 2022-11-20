import 'dart:convert';
import 'dart:developer';

import 'package:shelf/shelf.dart';
import 'package:treeserver/app/enums/message_type.dart';
import 'package:treeserver/app/logger/model.dart';
import 'package:treeserver/services/initializer/hive_initializer.dart';

import 'user_model.dart';

class UserDomain {
  static Future<List<User>> getAllWithoutRequest() async {
    List<User> target = [];
    var data = (await HiveWorker.users.getAll(
      await HiveWorker.users.getAllKeys(),
    ));
    for (var element in data) {
      target.add(User.fromMap({
        "username": element['username'],
        'password': element['password'],
        'age': element['age']
      }));
    }
    await LoggerDomain.add(Message(
        data: "getAllWithoutReques",
        type: MessageType.user,
        time: DateTime.now()));
    return target;
  }

  static Future<Response> postUser(User user) async {
    await HiveWorker.users.put(user.username, user.toMap());
    LoggerDomain.add(Message(
        data: "postUser", type: MessageType.user, time: DateTime.now()));
    return Response.ok(user.toJson());
  }

  static Future<Response> postUserResponse(Request request) async {
    var query = await request.readAsString();
    var queryparams = json.decode(query);
    log(queryparams.toString());
    try {
      (queryparams as Map<String, dynamic>)
          .keys
          .toList()
          .firstWhere((element) => element == "intent")
          .isEmpty;
    } catch (e) {
      log('no intent provided', error: e);
      await LoggerDomain.add(Message(
          data: "postUserResponse ERROR",
          type: MessageType.user,
          time: DateTime.now()));
      return Response.forbidden(
          "no intent provided. Is this register or login?");
    }
    User user = User.fromMap(queryparams);
    if (queryparams["intent"] == "register") {
      if ((await HiveWorker.users.getAll([user.username])).isEmpty) {
        await LoggerDomain.add(Message(
            data: "postUserResponse ERROR",
            type: MessageType.user,
            time: DateTime.now()));
        return Response.forbidden("already taken");
      }
      HiveWorker.users.put(user.username, user.toMap());
      await LoggerDomain.add(Message(
          data: "postUserResponse",
          type: MessageType.user,
          time: DateTime.now()));
      return Response.ok("registred");
    }

    if ((await HiveWorker.users.get(user.username)) == null) {
      await LoggerDomain.add(Message(
          data: "postUserResponse",
          type: MessageType.user,
          time: DateTime.now()));
      return Response.forbidden("user not found");
    }
    if (((await HiveWorker.users.get(user.username))['password'] !=
        queryparams['password'])) {
      await LoggerDomain.add(Message(
          data: "postUserResponse ERROR",
          type: MessageType.user,
          time: DateTime.now()));
      return Response.forbidden("password incorrect");
    }
    await LoggerDomain.add(Message(
        data: "postUserResponse",
        type: MessageType.user,
        time: DateTime.now()));
    return Response.ok("ok");
  }

  static Future<Response> getUserResponse(Request request) async {
    var loginPassword = json
        .decode(await request.readAsString()); //{'login':...,''password': ...}
    var logins = await HiveWorker.users.getAll(loginPassword['login']);
    if (logins.isNotEmpty) {
      if (logins.firstWhere(
          (element) => element['password'] == loginPassword['password'])) {
        await LoggerDomain.add(Message(
            data: "getUserResponse",
            type: MessageType.user,
            time: DateTime.now()));
        return Response.ok('accepted');
      }
    }
    await LoggerDomain.add(Message(
        data: "getUserResponse ERROR",
        type: MessageType.user,
        time: DateTime.now()));
    return Response.unauthorized("not found");
  }

  static Future<Map<String, dynamic>> getUsers() async {
    var target = await HiveWorker.users.getAllValues();
    log(target.toString());
    await LoggerDomain.add(Message(
        data: "getUsers", type: MessageType.user, time: DateTime.now()));
    return target;
  }
}
