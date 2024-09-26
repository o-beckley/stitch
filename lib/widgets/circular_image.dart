import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/placeholders.dart';

class CircularImage extends StatelessWidget {
  final String? imageUrl;
  final double? radius;

  const CircularImage({
    this.imageUrl,
    this.radius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: radius != null ? radius! * 2 : null,
      child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: context.watch<UIColors>().surfaceContainer,
            borderRadius: radius != null ? BorderRadius.circular(radius!) : null,
          ),
          child: imageUrl != null
          ? CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            errorWidget: (context, url, _) => ImagePlaceholder(radius: radius),
          )
          : ImagePlaceholder(radius: radius)
      ),
    );
  }
}