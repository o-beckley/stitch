import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/models/product_model.dart';
import 'package:stitch/screens/authentication/create_account_screen.dart';
import 'package:stitch/screens/authentication/forgot_password_screen.dart';
import 'package:stitch/screens/authentication/password_screen.dart';
import 'package:stitch/screens/authentication/reset_email_sent_screen.dart';
import 'package:stitch/screens/authentication/set_preferences_screen.dart';
import 'package:stitch/screens/authentication/sign_in_screen.dart';
import 'package:stitch/screens/authentication/splash_screen.dart';
import 'package:stitch/screens/home/cart_screen.dart';
import 'package:stitch/screens/home/home.dart';
import 'package:stitch/screens/home/product_screen.dart';

final GoRouter routerConfig = GoRouter( // TODO: add routing animations
  initialLocation: RoutePaths.splashScreen,
  errorBuilder: (context, state) => const ErrorBuilder(),
  routes: [
    GoRoute(
      path: RoutePaths.cartScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const CartScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.createAccountScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const CreateAccountScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.forgotPasswordScreen,
      pageBuilder: (context, state){
        final data = state.extra as Map<String, String>?;
        final email = data?['email'];
        return CupertinoPage(
          child: ForgotPasswordScreen(email: email),
          key: state.pageKey
        );
      }
    ),
    GoRoute(
      path: RoutePaths.home,
      pageBuilder: (context, state) => CupertinoPage(
        child: const Home(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.passwordScreen,
      pageBuilder: (context, state){
        final data = state.extra as Map<String, String>?;
        final email = data?['email'];
        if(email != null){
          return CupertinoPage(
              child: PasswordScreen(email: email),
              key: state.pageKey
          );
        }
        return CupertinoPage(
          child: const ErrorBuilder(message: 'The email was not passed while navigating to the password screen',),
          key: state.pageKey
        );
      }
    ),
    GoRoute(
      path: RoutePaths.productScreen,
      pageBuilder: (context, state){
        final data = state.extra as Map<String, dynamic>?;
        final product = data?['product'] as Product?;
        if(product != null){
          return CupertinoPage(
              child: ProductScreen(product: product),
              key: state.pageKey
          );
        }
        return CupertinoPage(
          child: const ErrorBuilder(message: 'The product object was not passed while navigating to the product screen',),
          key: state.pageKey
        );
      }
    ),
    GoRoute(
      path: RoutePaths.resetEmailSentScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const ResetEmailSentScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.setPreferencesScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const SetPreferencesScreen(),
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
  final String? message;
  const ErrorBuilder({
    this.message,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          message ?? 'Navigation error has occurred',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.error
          ),
        ),
      ),
    );
  }
}