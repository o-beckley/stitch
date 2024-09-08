import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/network_services/auth_service.dart';
import 'package:stitch/widgets/bottom_navigation_bar.dart';
import 'package:stitch/widgets/buttons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: CustomFilledButton(
                label: 'Sign out',
                onTap: (){
                  context.read<AuthService>().signOut();
                },
              ),
            ),
          ),
          CustomBottomNavigationBar(
            iconPaths: [
              AssetPaths.homeIcon,
              AssetPaths.notificationIcon,
              AssetPaths.ordersIcon,
              AssetPaths.profileIcon,
            ],
          )
        ],
      ),
    );
  }
}
