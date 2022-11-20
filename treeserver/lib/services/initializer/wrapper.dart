import 'package:treeserver/services/initializer/hive_initializer.dart';

class InitializerWrapper {
  static Future<void> init() async {
    await HiveWorker.init();
  }
}
