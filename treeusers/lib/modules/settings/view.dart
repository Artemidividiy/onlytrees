import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:treeusers/main.dart';
import 'package:treeusers/repositories/user.dart';

class SettingsView extends StatefulHookConsumerWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider.notifier);
    return Scaffold(body: Center(child: Text(user.data.data.username)));
  }
}
