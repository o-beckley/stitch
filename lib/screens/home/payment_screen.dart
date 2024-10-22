import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/app_bar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.watch<UIColors>().primary,
        child: Icon(
          Icons.add,
          color: context.watch<UIColors>().onPrimaryContainer,
        ),
        onPressed: (){
          // TODO: show a modal bottom sheet with the payment form
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(0.05.sw),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: CustomSliverAppBar(
                title: "Payment"
              ),
            )
          ],
        ),
      ),
    );
  }
}
