import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/message_type.dart';

class Logger {
  List<Message> logs;
  Logger({
    required this.logs,
  });

  Logger copyWith({
    List<Message>? logs,
  }) {
    return Logger(
      logs: logs ?? this.logs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'logs': logs.map((x) => x.toMap()).toList(),
    };
  }

  factory Logger.fromMap(Map<String, dynamic> map) {
    return Logger(
      logs: List<Message>.from(map['logs']?.map((x) => Message.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Logger.fromJson(String source) => Logger.fromMap(json.decode(source));

  @override
  String toString() => 'Logger(logs: $logs)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Logger && listEquals(other.logs, logs);
  }

  @override
  int get hashCode => logs.hashCode;
  factory Logger.empty() => Logger(logs: []);
}

class LoggerDomain {
  static late Logger logger;

  static Future<void> init() async {
    logger = Logger.empty();
    await getFromMemory();
  }

  static Future<void> getFromMemory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getStringList("logs");
  }

  static Future<void> add(Message m) async {
    logger.logs.add(m);
    final prefs = await SharedPreferences.getInstance();
    var tmp = prefs.getStringList('logs');
    tmp ??= [];
    tmp.add(m.toMap().toString());
    await prefs.setStringList("logs", tmp);
  }

  static void getMessages() => logger.logs;

  static List<Widget> returnAsWidget() => logger.logs
      .map((e) => Padding(
            child: e.returnAsWidget(),
            padding: EdgeInsets.all(8),
          ))
      .toList();
}

class Message {
  String data;
  MessageType type;
  DateTime time;
  Message({
    required this.type,
    required this.data,
    required this.time,
  });

  Widget returnAsWidget() => Container(
        constraints: BoxConstraints.loose(Size(Size.infinite.width, 130)),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(24)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "message",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(data),
              Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    "type",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: getColor()),
                  ),
                  Text(type.name),
                ]),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [Text("time:"), Text(time.toString())])
              ]),
            ]),
      );

  Message copyWith({String? data, DateTime? time, MessageType? type}) {
    return Message(
      type: type ?? this.type,
      data: data ?? this.data,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'time': time.millisecondsSinceEpoch,
      'type': type.toString()
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      type: map['type'],
      data: map['data'] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() => 'Message(data: $data, time: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message && other.data == data && other.time == time;
  }

  @override
  int get hashCode => data.hashCode ^ time.hashCode;

  Color getColor() {
    switch (type) {
      case MessageType.note:
        return Colors.primaries[0];
        break;
      case MessageType.user:
        return Colors.primaries[1];
        break;
      default:
        return Colors.white;
    }
  }
}

class LoggerNotifier extends StateNotifier<LoggerDomain> {
  LoggerNotifier() : super(LoggerDomain());
}
