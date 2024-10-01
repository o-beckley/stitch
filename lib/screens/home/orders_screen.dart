import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/models/order_model.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/horizontal_picker.dart';
import 'package:stitch/widgets/loading_indicator.dart';
import 'package:stitch/widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}
final List<String> views = [
  'Processing',
  'Shipped',
  'Delivered',
  'Returned',
  'Cancelled',
];
List<StitchOrder>? orders;

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
      body: FutureBuilder(
        future: context.watch<UserManagementService>().getOrders(),
        builder: (context, snapshot) {
          if(snapshot.data != null && snapshot.data!.isNotEmpty){
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
                    endPadding: 0.05.sw,
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(0.05.sw),
                  sliver: SliverList.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: EdgeInsets.only(top: 0.025.sw),
                        child: OrderCard(order: snapshot.data![index]),
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
                  0.1.sw.verticalSpace,
                  CustomFilledButton(
                    label: "Explore categories",
                    onTap: (){
                      // TODO: do sum
                    },
                  )
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