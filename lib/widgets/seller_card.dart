import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stitch/models/seller_model.dart';
import 'package:stitch/network_services/product_provider_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/placeholders.dart';

class SellerCard extends StatelessWidget {
  final String id;

  const SellerCard({
    required this.id,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StitchSeller?>(
      future: context.read<ProductProviderService>().getSeller(id),
      builder: (context, snapshot){
        if(snapshot.data != null){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _CircularImage(
                    imageUrl: snapshot.data!.imageUrl,
                    radius: 0.075.sw,
                  ),
                  10.horizontalSpace,
                  CustomTextButton(
                    label: snapshot.data!.name,
                    onTap: (){
                      // TODO: navigate to seller page
                    },
                  ),
                ],
              ),
              10.verticalSpace,
              if(snapshot.data!.description != null)
                Text(
                  snapshot.data!.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.watch<UIColors>().outline
                  ),
                )
              else
                const SizedBox.shrink()
            ],
          );
        }
        return const _SellerCardLoading();
      },
    );
  }
}

class _SellerCardLoading extends StatelessWidget {
  const _SellerCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _CircularImage extends StatelessWidget {
  final String? imageUrl;
  final double? radius;

  const _CircularImage({
    this.imageUrl,
    this.radius,
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
