import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stitch/theme/color_theme.dart';

class CustomWideButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;

  const CustomWideButton({
    required this.label,
    this.onTap,
    this.trailing,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 50,
        child: Opacity(
          opacity: onTap == null ? 0.32 : 1,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: context.watch<UIColors>().primary
            ),
            child: trailing == null
            ? Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: context.watch<UIColors>().onPrimaryContainer
                ),
              ),
            )
            : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: context.watch<UIColors>().onPrimaryContainer
                    ),
                  ),
                  trailing!
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder(); // TODO: create filled button
  }
}
