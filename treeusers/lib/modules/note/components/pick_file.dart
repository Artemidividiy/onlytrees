import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PickFileWidget extends StatefulWidget {
  File? file;
  PickFileWidget({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  State<PickFileWidget> createState() => _PickFileWidgetState();
}

class _PickFileWidgetState extends State<PickFileWidget> {
  String? filename;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickFile,
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.primaries[1])),
        constraints: BoxConstraints.loose(Size(Size.infinite.width, 100)),
        child: Row(
          children: [
            Icon(Icons.file_open),
            Text(filename == null ? "pick file" : filename!)
          ],
        ),
      ),
    );
  }

  Future<void> pickFile() async {
    FilePickerResult? res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['usdz', 'obj', 'fbx', 'glTF', 'glb']);
    if (res != null) {
      setState(() {
        widget.file = File(res.paths.first!);
        filename =
            widget.file!.path.substring(widget.file!.path.lastIndexOf('/'));
      });
    }
  }
}
