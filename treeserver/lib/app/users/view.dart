import 'package:flutter/material.dart';
import 'package:treeserver/services/server/models/user_domain.dart';

import '../../services/server/models/user_model.dart';
import 'user_tile.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      primary: true,
      child: Column(
        children: [
          Text(
            'users',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
          ),
          FutureBuilder<List<User>>(
              future: UserDomain.getAllWithoutRequest(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.length != 1)
                    // ignore: curly_braces_in_flow_control_structures
                    return MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(8),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) =>
                              UserTile(user: snapshot.data![index])),
                    );
                  else
                    return UserTile(user: snapshot.data!.first);
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ],
      ),
    ));
  }
}
