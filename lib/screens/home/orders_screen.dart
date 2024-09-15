import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stitch/theme/color_theme.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
      body: const Center(
        child: Text('Orders'),
      ),
    );
  }
}
