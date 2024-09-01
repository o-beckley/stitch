import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/screens/authentication/sign_in_screen.dart';
import 'package:stitch/screens/authentication/splash_screen.dart';
import 'package:stitch/screens/home/home.dart';

final GoRouter routerConfig = GoRouter( // TODO: add routing animations
  initialLocation: RoutePaths.splashScreen,
  errorBuilder: (context, state) => const ErrorBuilder(),
  routes: [
    GoRoute(
      path: RoutePaths.home,
      pageBuilder: (context, state) => CupertinoPage(
        child: const Home(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.signInScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const SignInScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.splashScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const SplashScreen(),
        key: state.pageKey,
      ),
    ),
  ]
);

class ErrorBuilder extends StatelessWidget {
  const ErrorBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Navigation error has occurred',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.error
          ),
        ),
      ),
    );
  }
}