import 'package:flutter/material.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final int maxLines;
  final int? maxLength;

  const CustomTextField({
    required this.hintText,
    required this.controller,
    this.focusNode,
    this.onTapOutside,
    this.onEditingComplete,
    this.obscureText = false,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    super.key
  });

  Widget? _counter(
    BuildContext context,
    {
      required int currentLength,
      required int? maxLength,
      required bool isFocused,
    }
    ) {
    if(isFocused && maxLength != null){
      return Text(
        '$currentLength / $maxLength',
        semanticsLabel: 'character count',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: context.watch<UIColors>().outline
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 60
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: context.watch<UIColors>().surfaceContainer
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        maxLines: maxLines,
        maxLength: maxLength,
        buildCounter: _counter,
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
        validator: validator,
      ),
    );
  }
}