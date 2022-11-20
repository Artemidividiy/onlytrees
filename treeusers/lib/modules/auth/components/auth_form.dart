import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:treeusers/main.dart';
import 'package:http/http.dart' as http;
import 'package:treeusers/repositories/user.dart';
import 'package:treeusers/utils/connect.dart';

import '../../home/view.dart';

class AuthForm extends HookConsumerWidget {
  final GlobalKey<FormState> authFormKey = GlobalKey<FormState>();
  PageController controller;
  AuthForm({super.key, required this.controller});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Center(
      child: Form(
        key: authFormKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              autocorrect: false,
              decoration: const InputDecoration(labelText: "username"),
              onChanged: (_) => authFormKey.currentState!.validate(),
              validator: usernameValidator,
              controller: usernameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(labelText: "username"),
              autocorrect: false,
              onChanged: (_) => authFormKey.currentState!.validate(),
              validator: passwordValidator,
              controller: passwordController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () =>
                    auth(context, ref, usernameController, passwordController),
                child: const Text("auth")),
          ),
          TextButton(
              onPressed: () async => controller.nextPage(
                  duration: const Duration(milliseconds: 125),
                  curve: Curves.easeInOut),
              child: const Text("register"))
        ]),
      ),
    );
  }

  Future<void>? auth(
      BuildContext context,
      WidgetRef ref,
      TextEditingController usernameController,
      TextEditingController passwordController) async {
    if (authFormKey.currentState!.validate()) {
      try {
        var res = await http.post(Uri.parse(Connect.serverAdress! + "/users"),
            body: json.encode({
              "username": usernameController.text,
              "password": passwordController.text,
              "intent": "login"
            }),
            headers: {'content-type': "application/json"});
        if (res.statusCode == 200) {
          ref.watch(userProvider.notifier).update(
              updated: UserRepository(
                  data: User(
                      id: "01",
                      username: usernameController.text,
                      age: -1,
                      password: passwordController.text)));
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeView()));
        }
      } catch (e) {
        log("error", error: e);
        return;
      }
    }
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return "can't be empty";
  }

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) return "can't be empty";
  }
}
