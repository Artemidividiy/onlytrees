import 'package:flutter/material.dart';
import 'package:treeserver/services/server/models/user_model.dart';

class UserTile extends StatelessWidget {
  final User user;
  const UserTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: 120, maxWidth: Size.infinite.width),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), border: Border.all()),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Username: "),
              Text("${user.username}"),
            ],
          ),
          Text("Age:"),
          Text("${user.age}")
        ],
      ),
    );
  }
}
