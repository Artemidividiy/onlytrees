import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'model.dart';

final loggerProvider = StateProvider<LoggerDomain>((ref) {
  return LoggerDomain();
});

class LoggerPage extends ConsumerStatefulWidget {
  const LoggerPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoggerPageState();
}

class _LoggerPageState extends ConsumerState<LoggerPage> {
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          primary: true,
          child: Column(children: [
            Text(
              'logs',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
            ),
            StreamBuilder<void>(
                stream: LoggerDomain.getFromMemory()
                    .asStream()
                    .takeWhile((element) => true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: LoggerDomain.returnAsWidget());
                  return CircularProgressIndicator();
                }),
          ])),
    );
  }
}
