import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/router_config.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/theme/theme.dart';

void main() {
  runApp(const StitchApp());
}

class StitchApp extends StatelessWidget {
  const StitchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<UIColors>(create: (context) => UIColors())
      ],
      child: const Stitch(),
    );
  }
}


class Stitch extends StatefulWidget {
  const Stitch({super.key});

  @override
  State<Stitch> createState() => _StitchState();
}

class _StitchState extends State<Stitch> with WidgetsBindingObserver{
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    final uiColors = context.read<UIColors>();
    final brightness = PlatformDispatcher.instance.platformBrightness;
    uiColors.darkMode.value = brightness == Brightness.dark;
    super.didChangePlatformBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Stitch',
      debugShowCheckedModeBanner: false,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: routerConfig,
    );
  }
}
