import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/models/order_model.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/horizontal_picker.dart';
import 'package:stitch/widgets/loading_indicator.dart';
import 'package:stitch/widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
      body: FutureBuilder(
        future: context.watch<UserManagementService>().getOrders(),
        builder: (context, snapshot) {
          if(snapshot.data != null && snapshot.data!.isNotEmpty){
            final orders = snapshot.data!.where((e) => e.currentStatus == OrderStatus.values[selectedCategory]).toList();
            return CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(top: 0.05.sw),
                  sliver: SliverPersistentHeader(
                    delegate: CustomSliverAppBar(
                      hasBackButton: false,
                      title: "Orders"
                    ),
                  )
                ),
                SliverToBoxAdapter(
                  child: HorizontalPicker(
                    items: OrderStatus.values.map((e) => e.name).toList(),
                    startingIndex: selectedCategory,
                    endPadding: 0.05.sw,
                    onItemPicked: (index){
                      setState(() {
                        selectedCategory = index;
                      });
                    },
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(0.05.sw),
                  sliver: SliverList.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: EdgeInsets.only(top: 0.025.sw),
                        child: OrderCard(order: orders[index]),
                      );
                    },
                  ),
                )
              ],
            );
          }
          else if(snapshot.connectionState == ConnectionState.done){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AssetPaths.cartImage),
                  0.05.sw.verticalSpace,
                  Text(
                    "No orders yet",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            );
          }
          else {
            return Center(
              child: SizedBox.square(
                dimension: 0.05.sw,
                child: const LoadingIndicator(),
              ),
            );
          }
        }
      )
    );
  }
}