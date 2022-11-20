import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:lan_scanner/lan_scanner.dart';

class Connect {
  static String? serverAdress;
  static Future<void> connect() async {
    Map<int, String> devices = {};
    print("initializing connection");
    final port = 80;
    final subnet = "192.168.1";
    final timeout = Duration.zero;
    final scanner = LanScanner();
    final stream = scanner.icmpScan(subnet, timeout: timeout,
        progressCallback: (progress) {
      log('${progress * 100}%');
    });
    await stream.listen(
      (event) {
        if (event.isReachable) {
          devices[devices.length] = event.ip;
          log("found device on ${event.ip}");
        } else
          log("${event.ip} not found");
      },
    ).asFuture();
    for (var device in devices.values) {
      try {
        log("pinging $device");
        var res = await http.get(Uri.parse('http://$device:8080/ping'));
        if (res.body == "treeserver") {
          serverAdress = "http://" + device + ":8080";
          return;
        }
      } catch (e) {
        log("not a treeserver");
      }
    }
  }
}
