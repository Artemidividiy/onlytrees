import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:treeserver/app/enums/message_type.dart';
import 'package:treeserver/app/logger/model.dart';
import 'package:treeserver/app/logger/view.dart';

class HiveWorker {
  static late BoxCollection collection;
  static late CollectionBox users, notes;
  static Future<void> init() async {
    collection = await BoxCollection.open("tree", {"users", "notes"},
        path: (await getApplicationDocumentsDirectory()).path);
    users = await collection.openBox("users");
    notes = await collection.openBox("notes");
    await LoggerDomain.add(Message(
        data: "hive initialized",
        type: MessageType.miscellaneous,
        time: DateTime.now()));
  }
}
