import 'package:flutter/material.dart';
import 'package:stitch/main.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TapRegionCallback? onTapOutside;
  const CustomTextField({
    required this.hintText,
    required this.controller,
    this.onTapOutside,
    super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: context.watch<UIColors>().surfaceContainer
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: context.watch<UIColors>().outline
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15)
            ),
            onTapOutside: onTapOutside ?? (_) => FocusScope.of(context).requestFocus(FocusNode()),
          ),
        )
    );
  }
}