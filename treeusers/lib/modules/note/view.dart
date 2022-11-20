import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:treeusers/modules/home/view.dart';
import 'package:treeusers/modules/note/components/pick_file.dart';
import 'package:treeusers/repositories/user.dart';

import '../../enums/notetype.dart';
import '../../repositories/note.dart';
import '../../utils/connect.dart';

final _choiceChip = StateProvider<int>((ref) {
  return 0;
});

final _noteProvider = StateProvider<Note>(
  (ref) {
    return Note.empty();
  },
);

class NoteView {
  static Widget create() => _NoteCreateView();
  static Widget read(Note note) => _NoteReadView(note);
}

class _NoteCreateView extends ConsumerWidget {
  _NoteCreateView({super.key});
  GlobalKey<FormState> noteFormKey = GlobalKey<FormState>();
  TextEditingController noteTextController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref.watch(_noteProvider);
    final typeSelected = ref.watch(_choiceChip);
    return Scaffold(
        body: SafeArea(
      child: Form(
        key: noteFormKey,
        child: Column(
          children: [
            Text("type"),
            Wrap(
                children: List.generate(
                    NoteType.values.length,
                    (index) => ChoiceChip(
                          onSelected: (value) =>
                              ref.read(_choiceChip.notifier).state = index,
                          label: Text(NoteType.values[index].toString()),
                          selected:
                              ref.read(_choiceChip) == index ? true : false,
                        ))),
            ref.read(_choiceChip.notifier).state == 0
                ? Column(
                    children: [
                      Text("Text:"),
                      TextFormField(
                        validator: noteTextValidator,
                        controller: noteTextController,
                        decoration: InputDecoration(hintText: "Note:"),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Text("File:"),
                      PickFileWidget(file: note.arData)
                    ],
                  ),
            TextButton(
                onPressed: () => submit(ref, context), child: Text("submit"))
          ],
        ),
      ),
    ));
  }

  void submit(WidgetRef ref, BuildContext context) async {
    if (noteFormKey.currentState!.validate()) {
      try {
        Note note = Note(
            createdAt: DateTime.now(),
            id: "posting",
            author: ref.read(userProvider.notifier).data,
            type: ref.read(_choiceChip.notifier).state == 0
                ? NoteType.String
                : NoteType.AR,
            textData: noteTextController.text.isEmpty
                ? null
                : noteTextController.text,
            arData: ref.read(_noteProvider.notifier).state.arData == null
                ? null
                : ref.read(_noteProvider.notifier).state.arData);
        NoteRepository(data: [note]).push(context, note);
      } catch (e) {
        log(e.toString());
      }
    }
  }

  String? noteTextValidator(String? value) {
    if (value == null || value.isEmpty) return "Can't be empty";
  }
}

class _NoteReadView extends ConsumerStatefulWidget {
  final Note note;
  const _NoteReadView(this.note, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __NoteReadViewState();
}

class __NoteReadViewState extends ConsumerState<_NoteReadView> {
  @override
  Widget build(BuildContext context) {
    print(widget.note);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Note:",
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          Text(widget.note.textData!),
          Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(
              "by: ${widget.note.author.data.username}",
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.end,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "created At: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(generatedCreatedAt())
              ]),
        ],
      ),
    );
  }

  String generatedCreatedAt() {
    String toTwoSignes(String value) {
      if (value.length == 1) return "0$value";
      return value;
    }

    DateTime dt = widget.note.createdAt;
    String target =
        "${toTwoSignes(dt.month.toString())}:${toTwoSignes(dt.day.toString())}";

    if (dt.year == DateTime.now().year) {
      target =
          "${dt.year}:$target:${toTwoSignes(dt.hour.toString())}:${toTwoSignes(dt.minute.toString())}";
    }
    return target;
  }
}
