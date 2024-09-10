import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/tonal_elevation.dart';


class ImagePlaceholder extends StatelessWidget {
  final double? width, height, radius;
  const ImagePlaceholder({
    this.width,
    this.height,
    this.radius,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: radius != null
                  ? BorderRadius.circular(radius!)
                  : null,
              color: (context).watch<UIColors>().surfaceContainer.tonalElevation(Elevation.level2, context)
          ),
        ),
      ),
    );
  }
}

class TextPlaceHolder extends StatelessWidget {
  final double height, width;
  const TextPlaceHolder({
    required this.height,
    required this.width,
    super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height/2),
          color: (context).watch<UIColors>().surfaceContainer.tonalElevation(Elevation.level2, context)
        )
      ),
    );
  }
}