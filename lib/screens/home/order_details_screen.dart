import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/models/order_item_model.dart';
import 'package:stitch/models/order_model.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/cart_item_card.dart';
import 'package:stitch/widgets/custom_tile.dart';

class OrderDetailsScreen extends StatefulWidget {
  final StitchOrder order;

  const OrderDetailsScreen({
    required this.order,
    super.key
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _shouldShowOrderItems = false;
  List<OrderItem> orderItems =  [];
  int length = 1;

  void _showItems(){
    orderItems = widget.order.items;
  }
  void _removeItems(){
    orderItems = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
      body: Padding(
        padding: EdgeInsets.all(0.05.sw),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: CustomSliverAppBar(
                title: "Order #${widget.order.id}",
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.025.sw),
                child: _DisplayOrderState(status: 'Delivered', timestamp: widget.order.status[OrderStatus.delivered]),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.025.sw),
                child: _DisplayOrderState(status: 'In transit', timestamp: widget.order.status[OrderStatus.transit]),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.025.sw),
                child: _DisplayOrderState(status: 'Order confirmed', timestamp: widget.order.status[OrderStatus.confirmed]),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.025.sw),
                child: _DisplayOrderState(status: 'Order placed', timestamp: widget.order.status[OrderStatus.placed]),
              ),
            ),
            SliverToBoxAdapter(
              child: 0.1.sw.verticalSpace,
            ),
            SliverToBoxAdapter(
              child: Text(
                "Order items",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              )
            ),
            SliverToBoxAdapter(
              child: 0.025.sw.verticalSpace,
            ),
            SliverToBoxAdapter(
              child: CustomTile(
                title: "${widget.order.items.length} ${widget.order.items.length > 1 ? 'items' : 'item'}",
                leading: SvgPicture.asset(
                  AssetPaths.ordersIcon,
                  colorFilter: ColorFilter.mode(
                      context.watch<UIColors>().onSurface,
                      BlendMode.srcIn
                  ),
                ),
                trailing: CustomTextButton(
                  label: _shouldShowOrderItems ? "Collapse" : "View all",
                  color: context.watch<UIColors>().primary,
                  onTap: (){
                    setState(() {
                      _shouldShowOrderItems = !_shouldShowOrderItems;
                    });
                    if(_shouldShowOrderItems){
                      _showItems();
                    }
                    else {
                      _removeItems();
                    }
                  },
                ),
              ),
            ),
            SliverList.builder(
              itemCount: orderItems.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: EdgeInsets.only(top: 0.05.sw),
                  child: CartItemCard(item: orderItems[index]),
                );
              },
            ),
            SliverToBoxAdapter(
              child: 0.1.sw.verticalSpace,
            ),
            SliverToBoxAdapter(
                child: Text(
                  "Shipping details",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                )
            ),
            SliverToBoxAdapter(
              child: 0.025.sw.verticalSpace,
            ),
            SliverToBoxAdapter(
              child: CustomTile(
                title: "Shipping details", //TODO
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisplayOrderState extends StatelessWidget {
  final String status;
  final DateTime? timestamp;
  
  const _DisplayOrderState({
    required this.status,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox.square(
          dimension: 20,
          child: CustomSvgIconButton(
            svgIconPath: AssetPaths.checkIcon,
            backgroundColor: timestamp != null
              ? context.watch<UIColors>().primary
              : context.watch<UIColors>().primary.withOpacity(0.32),

            iconColor: context.watch<UIColors>().onPrimaryContainer,
          ),
        ),
        0.02.sw.horizontalSpace,
        Text(
          status,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: timestamp != null
              ? context.watch<UIColors>().onSurface
              : context.watch<UIColors>().onSurface.withOpacity(0.32)
          )
        ),
        const Expanded(child: SizedBox()),
        timestamp != null
          ? Text(
            DateFormat("d MMM").format(timestamp!),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: context.watch<UIColors>().outline,
              fontWeight: FontWeight.bold
            ),
          )
          : const SizedBox.shrink()
      ],
    );
  }
}
