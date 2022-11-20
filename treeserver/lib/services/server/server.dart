import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:treeserver/services/server/models/note_domain.dart';

import '../../app/enums/message_type.dart';
import '../../app/logger/model.dart';
import 'models/user_domain.dart';

// Configure routes.
final _router = Router()
  ..post('/users', _userHandler)
  ..get('/ping', _pingHandler)
  ..get('/notes', _noteHandler)
  ..post('/notes', _noteHandler)
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _pingHandler(Request req) {
  return Response.ok("treeserver");
}

Future<Response> _noteHandler(Request req) async {
  switch (req.method) {
    case "GET":
      return NoteDomain.getAll(req);
      break;
    default:
      return NoteDomain.post(req);
  }
}

Future<Response> _userHandler(Request req) async {
  return await UserDomain.postUserResponse(req);
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

Future<void> init(List<String>? args) async {
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
  await LoggerDomain.add(Message(
      data: "Server listening on port ${server.port}",
      type: MessageType.miscellaneous,
      time: DateTime.now()));
}
