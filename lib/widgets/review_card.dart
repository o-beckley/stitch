import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/models/review_model.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/utils/datetime_utils.dart';
import 'package:provider/provider.dart';
import 'package:stitch/widgets/placeholders.dart';

class ReviewCard extends StatelessWidget {
  final ProductReview review;

  const ReviewCard({
    required this.review,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder(
              future: context.read<UserManagementService>().getUser(review.reviewerId),
              builder: (context, snapshot){
                if(snapshot.data != null){
                  return Flexible(
                    child: Text(
                      '${snapshot.data!.firstName ?? ''} ${snapshot.data!.lastName ?? ''}',
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }
                else{
                  return const TextPlaceHolder(height: 14, width: 100);
                }
              }
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                5,
                (index) => Padding(
                  padding: const EdgeInsets.all(2),
                  child: SvgPicture.asset(
                    AssetPaths.starIcon,
                    colorFilter: ColorFilter.mode(
                        index + 1 <= review.rating
                            ? context.watch<UIColors>().primary
                            : context.watch<UIColors>().outline,
                        BlendMode.srcIn
                    ),
                  ),
                )
              ),
            ),
          ],
        ),
        Text(
          review.review,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        Text(
          '${review.timeStamp.timeDifference} ago',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: context.watch<UIColors>().onSurface.withOpacity(0.5)
          ),
        )
      ],
    );
  }
}
