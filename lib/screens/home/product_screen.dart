import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:provider/provider.dart';
import 'package:stitch/models/order_item_model.dart';
import 'package:stitch/models/product_model.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/utils/toasts.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/bottom_sheet_selector.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/custom_network_image.dart';
import 'package:stitch/widgets/review_card.dart';
import 'package:stitch/widgets/seller_card.dart';

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
  late bool inFavourites;
  int imageIndex = 0;
  int? selectedSizeIndex;
  int? selectedColorIndex;
  int quantity = 1;
  bool isAddingItem = false;

  @override
  void initState(){
    super.initState();
    inFavourites = context.read<UserManagementService>()
        .inFavourites(widget.product.id);
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
                          onTap: () async {
                            final userService = context.read<UserManagementService>();
                            if(userService.inFavourites(widget.product.id)){
                              userService.removeFromFavourites(widget.product.id);
                            }
                            else{
                              userService.addToFavourites(widget.product.id);
                            }
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
                    child: Hero(
                      tag: "product_name_${widget.product.id}",
                      child: Text(
                        widget.product.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: 0.02.sw.verticalSpace,
                  ),
                  SliverToBoxAdapter(
                    child: Hero(
                      tag: "product_price_${widget.product.id}",
                      child: Text(
                        '\$${widget.product.price}', //TODO: handle the currency
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: context.watch<UIColors>().primary
                        )
                      ),
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
                            disabled: widget.product.amountLeft < quantity + 1,
                            onTap: (){
                              setState(() {
                                quantity += 1;
                              });
                            },
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
                            disabled: quantity <= 1,
                            onTap: (){
                              setState(() {
                                quantity -= 1;
                              });
                            },
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.watch<UIColors>().outline
                      ),
                    )
                  ),
                  SliverToBoxAdapter(
                    child: 0.15.sw.verticalSpace,
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seller',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        10.verticalSpace,
                        SellerCard(id: widget.product.sellerId),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: 0.15.sw.verticalSpace,
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
                                padding: EdgeInsets.symmetric(vertical: 0.04.sw),
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
                label: '\$${(widget.product.price * quantity).toStringAsFixed(2)}',
                trailing:  Text(
                  'Add to cart',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: context.watch<UIColors>().onPrimaryContainer
                  ),
                ),
                disabled: isAddingItem,
                onTap: _addItemToCart
              ),
            )
          ],
        ),
      )
    );
  }

  void _addItemToCart() async {
    setState(() {isAddingItem = true;});
    if(selectedColorIndex != null && selectedSizeIndex != null) {
      final bool itemAdded = await context.read<UserManagementService>().addToCart(
          OrderItem(
            productId: widget.product.id,
            quantity: quantity,
            size: widget.product.availableSizes[selectedSizeIndex!],
            color: widget.product.availableColors[selectedColorIndex!]
          )
      );
      if(itemAdded && mounted){
        context.pop();
      }
      else if (mounted){
        Toasts.showToast("Item couldn't be added. Try again later", context);
      }
    }
    else{
      Toasts.showToast("Please select a color and size", context);
    }
    setState(() {isAddingItem = false;});
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
        child: CustomNetworkImage(imageUrl: widget.product.imageUrls[index]),
      ),
    );
  }
}
