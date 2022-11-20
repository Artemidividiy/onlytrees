import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:treeusers/main.dart';
import 'package:treeusers/modules/auth/components/auth_form.dart';
import 'package:treeusers/repositories/user.dart';

import '../home/view.dart';
import 'components/register_form.dart';

class AuthView extends HookConsumerWidget {
  AuthView({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageController pageViewController = PageController();
    final user = ref.watch(userProvider);
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: PageView(
        controller: pageViewController,
        children: [
          AuthForm(controller: pageViewController),
          RegisterView(
            controller: pageViewController,
          )
        ],
      ),
    );
  }
}
