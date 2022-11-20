import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileWorker {
  static Future<File> getFile(String id) async {
    var path = await getApplicationDocumentsDirectory();
    return File(path.path + id);
  }

  static Future<bool> storeFile(String id, List<int> bytesToWrite) async {
    try {
      var path = await getApplicationDocumentsDirectory();
      File tmp = File(path.path + id);
      tmp.writeAsBytesSync(bytesToWrite);
      return true;
    } catch (e) {
      log("something went wrong while writing file to storage", error: e);
      return false;
    }
  }
}
