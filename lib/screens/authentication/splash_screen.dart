import 'package:flutter/material.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/network_services/auth_service.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    _authenticate();
  }

  void _authenticate() async {
    await Future.delayed(const Duration(seconds: 1));
    if(mounted) {
      final auth = context.read<AuthService>();
      final userService = context.read<UserManagementService>();
      if (auth.isSignedIn) {
        userService.fetchCurrentUser()
        .then(
          (_){
            if(mounted){
              context.pushReplacement(RoutePaths.home);
            }
          }
        );
      }
      else {
        context.pushReplacement(RoutePaths.signInScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiColors = context.watch<UIColors>();
    return Scaffold(
      backgroundColor: uiColors.primary,
      body: Center(
        child: Text(
          'Stitch.',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: uiColors.onPrimaryContainer,
            fontWeight: FontWeight.bold
          ),
        )
      )
    );
  }
}
