import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/utils/router_utils.dart';

class ResetEmailSentScreen extends StatelessWidget {
  const ResetEmailSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.square(
                  dimension: 0.4.sw,
                  child: Image.asset(AssetPaths.mailImage)),
              Text(
                'We sent you an email to reset your password',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              0.05.sw.verticalSpace,
              CustomFilledButton(
                label: 'Return to Login',
                onTap: (){
                  GoRouter.of(context).clearStackAndNavigate(RoutePaths.signInScreen);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
