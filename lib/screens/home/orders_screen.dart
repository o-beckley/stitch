import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stitch/models/order_model.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/horizontal_picker.dart';

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

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(top: 0.05.sw),
            sliver: SliverPersistentHeader(
              delegate: CustomSliverAppBar(
                hasBackButton: false,
                title: 'Orders'
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: HorizontalPicker(
              items: OrderStatus.values.map((e) => e.name).toList(),
              endPadding: 0.05.sw,
            ),
          )
        ],
      )
    );
  }
}