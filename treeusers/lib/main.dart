import 'dart:developer';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/splash/view.dart';
import 'repositories/user.dart';
import 'utils/connect.dart';

// We create a "provider", which will store a value (here "Hello world").
// By using a provider, this allows us to mock/override the value exposed.
final awaitingUsernameProvider = FutureProvider<UserRepository>((_) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await Future.delayed(
      Duration(seconds: 3), () async => await UserRepository.fromStorage());
});
final awaitingServerConnectProvider = FutureProvider<bool>((ref) async {
  await Connect.connect();
  return Connect.serverAdress == null ? false : true;
});

final awaitingInitializerProvider =
    FutureProvider<Map<String, bool?>>((ref) async {
  bool? isServerConnected;
  ref.watch(awaitingServerConnectProvider).when(
      data: (data) => isServerConnected = data,
      error: (obj, trace) => log("something went wrong", error: trace),
      loading: () => log("loading"));

  UserRepository userLoaded = UserRepository.empty();
  ref.watch(awaitingUsernameProvider).when(
      data: (data) => userLoaded = data,
      error: (obj, trace) => log("something went wrong", error: trace),
      loading: () => log("loading"));
  return {
    "isServerConnected": isServerConnected,
    "isUserLoaded": userLoaded != UserRepository.empty()
  };
});
// final usernameStateProvider =
//     StateNotifierProvider<UserNotifier, UserRepository>((ref) {
//   return UserNotifier(UserRepository.empty());
// });
void main() {
  runApp(
    // For widgets to be able to read providers, we need to wrap the entire
    // application in a "ProviderScope" widget.
    // This is where the state of our providers will be stored.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Note: MyApp is a HookConsumerWidget, from hooks_riverpod.
class MyApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(),
      theme: FlexThemeData.light(
        scheme: FlexScheme.outerSpace,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 20,
        appBarOpacity: 0.95,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          blendOnColors: false,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        // To use the playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.outerSpace,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 15,
        appBarOpacity: 0.90,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 30,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        // To use the playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,

      themeMode: ThemeMode.system,
    );
  }
}
