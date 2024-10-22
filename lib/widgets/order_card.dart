import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/models/order_model.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/custom_tile.dart';

class OrderCard extends StatelessWidget {
  final StitchOrder order;

  const OrderCard({
    required this.order,
    super.key
  });

  @override
  Widget build(BuildContext context){
    return CustomTile(
      onTap: (){
        context.push(RoutePaths.orderDetailsScreen, extra: order);
      },
      leading: SvgPicture.asset(
        AssetPaths.ordersIcon,
        colorFilter: ColorFilter.mode(
          context.watch<UIColors>().onSurface,
          BlendMode.srcIn
        ),
      ),
      title: "Order ${order.id}",
      subtitle: "${order.items.length} ${order.items.length > 1 ? 'items' : 'item'}",
      trailing:  SvgPicture.asset(
        AssetPaths.arrowForwardIcon,
        colorFilter: ColorFilter.mode(
            context.watch<UIColors>().onSurface,
            BlendMode.srcIn
        ),
      ),
    );
  }
}
