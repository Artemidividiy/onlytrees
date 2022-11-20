import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import 'package:treeserver/services/server/models/note_domain.dart';

import '../../../services/server/models/note_model.dart';
import 'note_tile.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  Stream<List<Note>> stream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 5));
      yield await NoteDomain.getAllWithoutRequest();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Stream<List<Note>> stream =
    //     Stream.periodic(Duration(seconds: 5), (_) async {
    //   return await NoteDomain.getAllWithoutRequest();
    // });
    return Scaffold(
      body: SingleChildScrollView(
        primary: true,
        child: Column(
          children: [
            Text(
              'notes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
            ),
            StreamBuilder<List<Note>>(
              stream: stream.call(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) =>
                        NoteTile(note: snapshot.data![index]),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
