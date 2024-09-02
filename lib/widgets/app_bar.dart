import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:provider/provider.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget {
  final bool hasBackButton;
  final String? title;
  const CustomAppBar({
    this.title,
    this.hasBackButton = true,
    super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: math.max(80, 0.25.sw),
      // height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          hasBackButton
          ? GestureDetector(
            onTap: () => context.pop(),
            child: SizedBox.square(
              dimension: 40,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: context.watch<UIColors>().surfaceContainer
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    AssetPaths.arrowBackIcon,
                    colorFilter: ColorFilter.mode(
                      context.watch<UIColors>().onSurface,
                      BlendMode.srcIn
                    ),
                  ),
                )
              ),
            ),
          )
          : const SizedBox.shrink(),
          title != null
          ? Text(
              title!,
              style: Theme.of(context).textTheme.titleMedium,
          )
          : const SizedBox.shrink(),
          hasBackButton ? 40.horizontalSpace : const SizedBox.shrink() // To balance the leading icon
        ],
      ),
    );
  }
}

class CustomSliverAppBar extends SliverPersistentHeaderDelegate {
  final String? title;
  final bool hasBackButton;
  CustomSliverAppBar({
    this.title,
    this.hasBackButton = true
  });

  @override
  double get maxExtent => 0.15.sw;

  @override
  double get minExtent => 0.15.sw;

  @override
  bool shouldRebuild(CustomSliverAppBar oldDelegate) {
    return false;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return CustomAppBar(
      title: title,
      hasBackButton: hasBackButton,
    );
  }
}