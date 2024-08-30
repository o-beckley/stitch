import 'package:flutter/material.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:provider/provider.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
