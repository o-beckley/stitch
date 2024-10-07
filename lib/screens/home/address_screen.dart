import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/app_bar.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
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
          // TODO: show a modal bottom sheet with the address form
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(0.05.sw),
        child: ListView(
          children: [
            CustomAppBar(title: "Address",)
          ],
        ),
      ),
    );
  }
}
