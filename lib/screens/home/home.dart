import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stitch/network_services/auth_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: (){
            context.read<AuthService>().signOut();
          },
          child: const Text('Home')
        ),
      ),
    );
  }
}
