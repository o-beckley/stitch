import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stitch/theme/color_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
      body: const Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}
