import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:provider/provider.dart';
import 'package:stitch/models/product_model.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/bottom_sheet_selector.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/placeholders.dart';
import 'package:stitch/widgets/review_card.dart';

class ProductScreen extends StatefulWidget {
  final Product product;

  const ProductScreen({
    required this.product,
    super.key
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool inFavourites = false;
  int imageIndex = 0;
  int? selectedSizeIndex;
  int? selectedColorIndex;
  int quantity = 1;

  @override
  void initState(){
    super.initState();
    /// TODO: get  inFavourite from the backend.
    /// if widget.product.id is in user.favourites
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
      body: Padding(
        padding: EdgeInsets.all(0.05.sw),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    floating: true,
                    delegate: CustomSliverAppBar(
                      actions: [
                        CustomSvgIconButton(
                          svgIconPath: inFavourites ? AssetPaths.heartFilledIcon : AssetPaths.heartIcon,
                          iconColor: inFavourites ? Colors.red : null,
                          onTap: (){
                            setState(() {
                              inFavourites = !inFavourites;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 0.6.sw,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.product.imageUrls.length,
                        itemBuilder: (context, index) => _buildImage(index),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: 0.05.sw.verticalSpace,
                  ),
                  SliverToBoxAdapter(
                    child: Text(
                      widget.product.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: 0.02.sw.verticalSpace,
                  ),
                  SliverToBoxAdapter(
                    child: Text(
                      '\$${widget.product.price}', //TODO: handle the currency
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: context.watch<UIColors>().primary
                      )
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: 0.1.sw.verticalSpace,
                  ),
                  SliverToBoxAdapter(
                    child: BottomSheetSelector(
                      label: 'Size',
                      items: widget.product.availableSizes,
                      onItemSelected: (index){
                        selectedSizeIndex = index;
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: 0.05.sw.verticalSpace,
                  ),
                  SliverToBoxAdapter(
                    child: BottomSheetSelector(
                      label: 'Color',
                      items: widget.product.availableColors.map((c) => c.name).toList(),
                      trailingWidgets: List.generate(widget.product.availableColors.length, _buildTrailingColor),
                      displayTrailingOnButton: true,
                      onItemSelected: (index){
                        selectedColorIndex = index;
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: 0.05.sw.verticalSpace,
                  ),
                  SliverToBoxAdapter(
                    child: CustomWideButton(
                      label: 'Quantity',
                      color: context.watch<UIColors>().outline,
                      backgroundColor: context.watch<UIColors>().surfaceContainer,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomSvgIconButton(
                            svgIconPath: AssetPaths.addIcon,
                            iconColor: context.watch<UIColors>().onPrimaryContainer,
                            backgroundColor: context.watch<UIColors>().primary,
                            onTap:widget.product.amountLeft >= quantity + 1
                            ? (){
                              setState(() {
                                quantity += 1;
                              });
                            }
                            : null,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              quantity.toString()
                            ),
                          ),
                          CustomSvgIconButton(
                            svgIconPath: AssetPaths.removeIcon,
                            iconColor: context.watch<UIColors>().onPrimaryContainer,
                            backgroundColor: context.watch<UIColors>().primary,
                            onTap: quantity > 1
                            ? (){
                              setState(() {
                                quantity -= 1;
                              });
                            }
                            : null,
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: 0.1.sw.verticalSpace,
                  ),
                  SliverToBoxAdapter(
                    child: Text(
                      widget.product.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: context.watch<UIColors>().outline
                      ),
                    )
                  ),
                  SliverToBoxAdapter(
                    child: 0.2.sw.verticalSpace,
                  ),
                  if(widget.product.reviews.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reviews',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          0.02.sw.verticalSpace,
                          Text(
                            '${_getRating()} Ratings',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          ... List.generate(
                              widget.product.reviews.length,
                              (index) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.03.sw),
                                child: ReviewCard(review: widget.product.reviews[index]),
                              )
                          ),
                        ],
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: Text(
                        'No reviews yet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: context.watch<UIColors>().outline
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(top: 0.02.sw),
              child: CustomWideButton(
                label: '\$${widget.product.price}',
                trailing:  Text(
                  'Add to cart',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: context.watch<UIColors>().onPrimaryContainer
                  ),
                ),
                onTap: (){
                  // TODO: add to cart
                },
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _buildTrailingColor(int index){
    const double width = 20;
    const double strokeWidth = 2;

    return SizedBox.square(
      dimension: width,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(width / 2)
        ),
        child: Padding(
          padding: const EdgeInsets.all(strokeWidth),
          child: Container(
            decoration: BoxDecoration(
              color: widget.product.availableColors[index].color,
              borderRadius: BorderRadius.circular((width - 2 * strokeWidth) / 2)
            ),
          ),
        ),
      ),
    );
  }
  double _getRating(){
    if(widget.product.reviews.isEmpty){
      return 0;
    }
    double total = 0;
    for (var r in widget.product.reviews){
      total += r.rating;
    }
    return total / widget.product.reviews.length;
  }
  
  Widget _buildImage(index){
    return Padding(
      padding: EdgeInsets.only(right: 0.02.sw),
      child: Hero(
        tag: widget.product.id + widget.product.imageUrls[index],
        child: CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl: widget.product.imageUrls[index],
          errorWidget: (context, url, _) => const ImagePlaceholder(),
        ),
      ),
    );
  }
}
