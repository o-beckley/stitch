import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/utils/router_utils.dart';
import 'package:stitch/widgets/buttons.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: context.watch<UIColors>().primary
        ),
        child: Center(
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(0.1.sw),
                    child: Image.asset(AssetPaths.purchaseSuccessImage),
                  )
              ),
              Container(
                decoration: BoxDecoration(
                  color: context.watch<UIColors>().surfaceContainer,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(0.1.sw)
                  )
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(0.1.sw),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Order placed successfully',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        0.05.sw.verticalSpace,
                        Text(
                          'You will receive an email confirmation',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: context.watch<UIColors>().outline
                          ),
                        ),
                        0.1.sw.verticalSpace,
                        CustomWideButton(
                          label: "Go back",
                          onTap: (){
                            GoRouter.of(context).clearStackAndNavigate(RoutePaths.home);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
