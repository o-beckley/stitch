import 'package:flutter/material.dart';

class SetPreferencesScreen extends StatefulWidget {
  const SetPreferencesScreen({super.key});

  @override
  State<SetPreferencesScreen> createState() => _SetPreferencesScreenState();
}

class _SetPreferencesScreenState extends State<SetPreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('select gender and age'),
      ),
    );
  }
}
