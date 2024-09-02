import 'package:flutter/material.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final bool obscureText;

  const CustomTextField({
    required this.hintText,
    required this.controller,
    this.focusNode,
    this.onTapOutside,
    this.onEditingComplete,
    this.obscureText = false,
    super.key
  });

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
            focusNode: focusNode,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: context.watch<UIColors>().outline
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 12
              ),
            ),
            onEditingComplete: onEditingComplete,
            onTapOutside: onTapOutside ?? (_) => FocusScope.of(context).requestFocus(FocusNode()),
          ),
        )
    );
  }
}