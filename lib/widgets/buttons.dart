import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stitch/theme/color_theme.dart';

class CustomWideButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? color;
  final Color? backgroundColor;

  const CustomWideButton({
    required this.label,
    this.onTap,
    this.trailing,
    this.color,
    this.backgroundColor,
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
                color: backgroundColor ?? context.watch<UIColors>().primary
            ),
            child: trailing == null
            ? Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color ?? context.watch<UIColors>().onPrimaryContainer
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
                      color: color ?? context.watch<UIColors>().onPrimaryContainer
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
  final String label;
  final VoidCallback? onTap;

  const CustomFilledButton({
    required this.label,
    this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.watch<UIColors>().primary,
                borderRadius: BorderRadius.circular(25)
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: context.watch<UIColors>().onPrimaryContainer
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  const CustomTextButton({
    required this.label,
    this.onTap,
    this.color,
    super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 40,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color ?? Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold
              )
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSvgIconButton extends StatelessWidget {
  final String svgIconPath;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double radius;

  const CustomSvgIconButton({
    required this.svgIconPath,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.radius = 40,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: radius,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? context.watch<UIColors>().surfaceContainer,
            borderRadius: BorderRadius.circular(radius / 2)
          ),
          child: Center(
            child: SvgPicture.asset(svgIconPath),
          ),
        ),
      ),
    );
  }
}
