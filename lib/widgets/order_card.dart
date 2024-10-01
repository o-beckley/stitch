import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitch/models/order_model.dart';

class OrderCard extends StatelessWidget {
  final StitchOrder order;

  const OrderCard({
    required this.order,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.2.sw,
      child: const Placeholder(),
    );
  }
}
