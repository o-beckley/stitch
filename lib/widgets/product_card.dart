import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/models/product_model.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/placeholders.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({
    required this.product,
    super.key
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>{
  // late bool inFavourites;

  // @override
  // void initState() {
  //   super.initState();
  //   inFavourites = context.read<UserManagementService>()
  //       .inFavourites(widget.product.id);
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.push(RoutePaths.productScreen, extra: {'product': widget.product});
      },
      child: SizedBox(
        width: 0.4.sw,
        child: AspectRatio(
          aspectRatio: 4/7,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: context.watch<UIColors>().surfaceContainer,
                  borderRadius: BorderRadius.circular(constraints.minWidth / 15),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Hero(
                            tag: widget.product.id + widget.product.imageUrls[0],
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: context.watch<UIColors>().surfaceContainer,
                                borderRadius: BorderRadius.circular(constraints.minWidth / 15),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: widget.product.imageUrls[0],
                                fit: BoxFit.cover,
                                errorWidget: (context, url, _){
                                  return const ImagePlaceholder();
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(constraints.minWidth / 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: "product_name_${widget.product.id}",
                                child: Text(
                                  widget.product.name,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              5.verticalSpace,
                              Hero(
                                tag: "product_price_${widget.product.id}",
                                child: Text( // TODO: add discounted price if any with a slash on the old price
                                  '\$${widget.product.price.toString()}', // TODO: use the currency of the user
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
