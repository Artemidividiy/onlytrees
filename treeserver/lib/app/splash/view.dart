import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:treeserver/app/notes/view.dart';
import 'package:treeserver/main.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(initializerProvider).when(
        data: (data) {
          if (data == false)
            return Scaffold(
              body: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.eco),
                    Icon(Icons.settings_applications_outlined)
                  ],
                ),
              ),
            );
          return NotesPage();
        },
        error: (obj, trace) => Scaffold(body: Center(child: Text("$trace"))),
        loading: () => Scaffold(
              body: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.eco),
                    Icon(Icons.settings_applications_outlined)
                  ],
                ),
              ),
            ));
  }
}
