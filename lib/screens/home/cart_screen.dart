import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/models/order_item_model.dart';
import 'package:stitch/network_services/product_provider_service.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/order_item_card.dart';
import 'package:stitch/widgets/loading_indicator.dart';
import 'package:stitch/widgets/placeholders.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<OrderItem>?> cartItems;
  late Future<double?> subtotal;
  late Future<double?> totalDeliveryFees;
  
  @override
  void initState(){
    super.initState();
    cartItems = context.read<UserManagementService>().getCartItems();
    getTotal(cartItems);
  }

  @override
  Widget build(BuildContext context) { //TODO: group by sellers
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
      body: Padding(
        padding: EdgeInsets.all(0.05.sw),
        child: FutureBuilder(
          future: cartItems,
          builder: (context, snapshot) {
            if(snapshot.data != null && snapshot.data!.isNotEmpty){
              return Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverPersistentHeader(
                          delegate: CustomSliverAppBar(
                            title: 'Cart'
                          ),
                        ),
                        SliverList.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index){
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.02.sw),
                              child: OrderItemCard(item: snapshot.data![index]),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: 0.02.sw),
                    child: Column(
                      children: [
                        priceWidgetThingy(),
                        0.05.sw.verticalSpace,
                        Hero(
                          tag: "checkout_place_order_button",
                          child: CustomWideButton(
                            label: 'Checkout',
                            onTap: () async {
                              context.push(
                                RoutePaths.checkoutScreen,
                                extra: snapshot.data!
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
            else if(snapshot.connectionState == ConnectionState.done){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AssetPaths.parcelImage),
                    0.025.sw.verticalSpace,
                    Text(
                      "Your cart is empty",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    0.05.sw.verticalSpace,
                    CustomFilledButton(
                      label: "Go back",
                      onTap: (){
                        if(context.canPop()){
                          context.pop();
                        }
                      },
                    )
                  ],
                ),
              );
            }
            else {
              return const Center(
                  child: LoadingIndicator()
              );
            }
          }
        ),
      )
    );
  }

  Widget priceWidgetThingy(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Subtotal",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: context.watch<UIColors>().outline
              ),
            ),
            FutureBuilder(
                future: subtotal,
                builder: (context, snapshot) {
                  if(snapshot.data != null){
                    return Text(
                      "${snapshot.data}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    );
                  }
                  return TextPlaceHolder(height: 14, width: 0.15.sw);
                }
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Delivery fee",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: context.watch<UIColors>().outline
              ),
            ),
            FutureBuilder(
                future: totalDeliveryFees,
                builder: (context, snapshot) {
                  if(snapshot.data != null){
                    return Text(
                      "${snapshot.data}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    );
                  }
                  return TextPlaceHolder(height: 14, width: 0.15.sw);
                }
            )
          ],
        ),
        Divider(
          color: context.watch<UIColors>().outline.withOpacity(0.32),
          thickness: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: context.watch<UIColors>().outline
              ),
            ),
            FutureBuilder(
                future: Future.wait([subtotal, totalDeliveryFees]),
                builder: (context, snapshot) {
                  if(snapshot.data != null){
                    return Text(
                      "${snapshot.data![0]! + snapshot.data![1]!}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    );
                  }
                  return TextPlaceHolder(height: 14, width: 0.15.sw);
                }
            )
          ],
        ),
      ],
    );
  }

  Future<double?> getSubtotal (List<OrderItem> items) async {
    double res = 0;
    for (var i in items){
      final product = await context.read<ProductProviderService>().getProduct(i.productId);
      if(product == null){
        return null;
      }
      res += product.price * i.quantity;
    }
    return res;
  }

  Future<double?> getDeliveryFees(List<OrderItem> items) async{
    // TODO: group by sellers first then get individual shipping fees of the sellers
    return 0;
  }
  
  void getTotal(Future<List<OrderItem>?> cartItems) async {
    final items = await cartItems;
    if(items != null) {
      subtotal = getSubtotal(items);
      totalDeliveryFees = getDeliveryFees(items);
    }
  }
}
