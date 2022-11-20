import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:treeusers/main.dart';
import 'package:treeusers/modules/home/components/note_tile.dart';
import 'package:treeusers/repositories/note.dart';
import 'package:treeusers/repositories/user.dart';

import '../note/view.dart';

final awaitingNotesProvider = FutureProvider<NoteRepository>((ref) async {
  return await NoteRepository.get();
});

class HomeView extends HookConsumerWidget {
  HomeView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(awaitingNotesProvider).when(
        data: (data) {
          if (data.data.length == 0) return Text("no notes");
          return Scaffold(
              appBar: AppBar(
                leadingWidth: 160,
                leading: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextButton.icon(
                    style: Theme.of(context).textButtonTheme.style!.copyWith(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).secondaryHeaderColor)),
                    label: Text("log out"),
                    onPressed: () async =>
                        ref.watch(userProvider.notifier).logout(context),
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                  onPressed: () => createNote(context),
                  label: Text("Create Note")),
              body: RefreshIndicator(
                onRefresh: () => ref.refresh(awaitingNotesProvider.future),
                child: ListView.builder(
                    itemCount: data.data.length,
                    itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: NoteTile(note: data.data[index]),
                        )),
              ));
        },
        error: (obj, trace) => Scaffold(
              body: Text(trace.toString()),
            ),
        loading: () => Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ));
  }

  void createNote(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NoteView.create()));
  }
}
