import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/network_services/auth_service.dart';
import 'package:stitch/screens/home/home_screen.dart';
import 'package:stitch/screens/home/notification_screen.dart';
import 'package:stitch/screens/home/orders_screen.dart';
import 'package:stitch/screens/home/profile_screen.dart';
import 'package:stitch/widgets/bottom_navigation_bar.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedScreenIndex = 0;

  @override
  void initState(){
    super.initState();
    context.read<AuthService>().handlePresence();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: selectedScreenIndex,
              children: const [
                HomeScreen(),
                NotificationScreen(),
                OrdersScreen(),
                ProfileScreen()
              ],
            )
          ),
          CustomBottomNavigationBar(
            iconPaths: const [
              AssetPaths.homeIcon,
              AssetPaths.notificationIcon,
              AssetPaths.ordersIcon,
              AssetPaths.profileIcon,
            ],
            onTap: (index){
              setState(() {
                selectedScreenIndex = index;
              });
            },
          )
        ],
      ),
    );
  }
}