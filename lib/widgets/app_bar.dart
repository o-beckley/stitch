import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/widgets/buttons.dart';

class CustomAppBar extends StatelessWidget {
  final bool hasBackButton;
  final String? title;
  final List<Widget>? actions;

  const CustomAppBar({
    this.title,
    this.hasBackButton = true,
    this.actions,
    super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: math.max(80, 0.25.sw),
      child: Stack(
        children: [
          hasBackButton
          ? Align(
            alignment: Alignment.centerLeft,
            child: CustomSvgIconButton(
              svgIconPath: AssetPaths.arrowBackIcon,
              onTap: (){
                if(context.canPop()){
                  context.pop();
                }
              },
            )
          )
          : const SizedBox.shrink(),

          title != null
          ? Align(
            alignment: Alignment.center,
            child: Text(
                title!,
                style: Theme.of(context).textTheme.titleMedium,
            ),
          )
          : const SizedBox.shrink(),

          actions != null
          ? Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            ),
          )
          : const SizedBox.shrink()
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