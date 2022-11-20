import 'package:flutter/material.dart';

import '../../../repositories/note.dart';
import '../../note/view.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  const NoteTile({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => NoteView.read(note))),
      child: Container(
        padding: EdgeInsets.all(8),
        // constraints: BoxConstraints.loose(Size(Size.infinite.width, 64)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), border: Border.all()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Content",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(note.textData ?? "it's an AR file"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Author",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(note.author.data.username.isNotEmpty
                        ? note.author.data.username
                        : "unknown"),
                  ],
                )
              ],
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text(
                "created At: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(generatedCreatedAt())
            ]),
          ],
        ),
      ),
    );
  }

  String generatedCreatedAt() {
    String toTwoSignes(String value) {
      if (value.length == 1) return "0$value";
      return value;
    }

    DateTime dt = note.createdAt;
    String target =
        "${toTwoSignes(dt.month.toString())}:${toTwoSignes(dt.day.toString())}";

    if (dt.year == DateTime.now().year) {
      target =
          "${dt.year}:$target:${toTwoSignes(dt.hour.toString())}:${toTwoSignes(dt.minute.toString())}";
    }
    return target;
  }
}
