import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:treeusers/main.dart';
import 'package:treeusers/modules/auth/view.dart';
import 'package:treeusers/modules/home/view.dart';
import 'package:treeusers/repositories/user.dart';

class SplashView extends StatefulHookConsumerWidget {
  const SplashView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(awaitingInitializerProvider).when(
        data: (data) {
          print(data);
          if (data['isServerConnected'] != null && !data['isServerConnected']!)
            return Scaffold(
                body: Center(
                    child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("no treeserver found"),
                LinearProgressIndicator()
              ],
            )));
          if (data['isServerConnected'] != null &&
              data['isServerConnected']! &&
              !data['isUserLoaded']!) return AuthView();
          if (data['isUserLoaded'] != null &&
              data['isServerConnected'] != null &&
              data['isUserLoaded']! &&
              data['isServerConnected']!) {
            print('redirecting');
            return HomeView();
          }

          return Scaffold(
            body: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.eco), Icon(Icons.portrait)],
              ),
            ),
          );
        },
        error: (obj, trace) => Scaffold(
              body: Center(
                child: Text("$obj + $trace"),
              ),
            ),
        loading: () => Scaffold(
              body: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.eco), Icon(Icons.portrait)],
                ),
              ),
            ));
  }
}
