import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/network_services/auth_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/utils/router_utils.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/custom_tile.dart';

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
      body: Padding(
        padding: EdgeInsets.all(0.05.sw),
        child: ListView(
          children: [
            CustomAppBar(hasBackButton: false),
            CustomTile(
              title: "Address",
              onTap: (){
                context.push(RoutePaths.addressScreen);
              },
              trailing: CustomSvgIconButton(svgIconPath: AssetPaths.arrowForwardIcon),
            ),
            20.verticalSpace,
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
