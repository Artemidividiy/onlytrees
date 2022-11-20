import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:treeusers/repositories/user.dart';
import 'package:http/http.dart' as http;
import '../../../utils/connect.dart';
import '../../home/view.dart';

final _ageStateProvider = StateProvider<int>((ref) {
  return 18;
});

class RegisterView extends HookConsumerWidget {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController ageController = TextEditingController(text: "18");
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  PageController controller;
  RegisterView({super.key, required this.controller});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Center(
      child: Form(
        key: registerFormKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              autocorrect: false,
              decoration: InputDecoration(labelText: "username"),
              onChanged: (_) => registerFormKey.currentState!.validate(),
              validator: usernameValidator,
              controller: usernameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(labelText: "password"),
              autocorrect: false,
              onChanged: (_) => registerFormKey.currentState!.validate(),
              validator: passwordValidator,
              controller: passwordController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(labelText: "confirm password"),
              autocorrect: false,
              onChanged: (_) => registerFormKey.currentState!.validate(),
              validator: passwordConfirmValidator,
              controller: passwordConfirmController,
            ),
          ),
          NumberPicker(
              value: int.parse(ageController.text),
              maxValue: 99,
              minValue: 1,
              onChanged: (newAge) {
                ref.read(_ageStateProvider.notifier).state = newAge;
                ageController.text = newAge.toString();
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () => register(
                      context,
                      ref,
                    ),
                child: const Text("register")),
          ),
          TextButton(
              onPressed: () => controller.previousPage(
                  duration: Duration(milliseconds: 125),
                  curve: Curves.easeInOut),
              child: Text('auth'))
        ]),
      ),
    );
  }

  Future<void>? register(
    BuildContext context,
    WidgetRef ref,
  ) async {
    if (registerFormKey.currentState!.validate()) {
      try {
        var res = await http.post(Uri.parse("${Connect.serverAdress!}/users"),
            body: json.encode({
              "username": usernameController.text,
              "password": passwordController.text,
              "age": int.parse(ageController.text),
              "passwordConfirmation": passwordConfirmController.text,
              "intent": "register"
            }),
            headers: {'content-type': "application/json"});
        if (res.statusCode == 200) {
          ref.watch(userProvider.notifier).update(
              updated: UserRepository(
                  data: User(
                      id: usernameController.text,
                      username: usernameController.text,
                      age: int.parse(ageController.text),
                      password: passwordController.text)));
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeView()));
        }
      } catch (e) {
        log("error", error: e);
      }
    }
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return "can't be empty";
  }

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) return "can't be empty";
  }

  String? passwordConfirmValidator(String? value) {
    if (value == null || value.isEmpty) return "can't be empty";
    if (value != passwordController.text)
      return "password and confirmation fields must be the same";
  }
}
