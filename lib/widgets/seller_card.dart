import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stitch/models/seller_model.dart';
import 'package:stitch/network_services/product_provider_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/circular_image.dart';
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
                  CircularImage(
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
  const _SellerCardLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircularImage(radius: 0.075.sw,),
            10.horizontalSpace,
            const TextPlaceHolder(height: 14, width: 100)
          ],
        ),
        0.02.sw.verticalSpace,
        TextPlaceHolder(height: 12, width: 0.9.sw),
        0.02.sw.verticalSpace,
        TextPlaceHolder(height: 12, width: 0.8.sw),
        0.02.sw.verticalSpace,
        TextPlaceHolder(height: 12, width: 0.85.sw),
        0.02.sw.verticalSpace,
        TextPlaceHolder(height: 12, width: 0.5.sw),
      ],
    );
  }
}
