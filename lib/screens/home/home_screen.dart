import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/network_services/auth_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/utils/router_utils.dart';
import 'package:stitch/widgets/buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomFilledButton(
              label: 'Sign out',
              onTap: () async {
                await context.read<AuthService>().signOut();
                if(context.mounted){
                  GoRouter.of(context).clearStackAndNavigate(RoutePaths.signInScreen);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
