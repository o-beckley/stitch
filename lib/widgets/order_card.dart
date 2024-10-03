import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/models/order_model.dart';
import 'package:stitch/theme/color_theme.dart';

class OrderCard extends StatelessWidget {
  final StitchOrder order;

  const OrderCard({
    required this.order,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.push(RoutePaths.orderDetailsScreen, extra: order);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.025.sw),
          color: context.watch<UIColors>().surfaceContainer
        ),
        child: Padding(
          padding: EdgeInsets.all(0.05.sw),
          child: Row(
            children: [
              SvgPicture.asset(
                AssetPaths.ordersIcon,
                colorFilter: ColorFilter.mode(
                  context.watch<UIColors>().onSurface,
                  BlendMode.srcIn
                ),
              ),
              0.05.sw.horizontalSpace,
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order #${order.id}",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    "${order.items.length} ${order.items.length > 1 ? 'items' : 'item'}",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: context.watch<UIColors>().outline
                    ),
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              SvgPicture.asset(
                AssetPaths.arrowForwardIcon,
                colorFilter: ColorFilter.mode(
                    context.watch<UIColors>().onSurface,
                    BlendMode.srcIn
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
