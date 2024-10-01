import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/cart_item_card.dart';
import 'package:stitch/widgets/loading_indicator.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) { //TODO: group by sellers
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
      body: Padding(
        padding: EdgeInsets.all(0.05.sw),
        child: FutureBuilder(
          future: context.read<UserManagementService>().getCartItems(),
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
                              child: CartItemCard(item: snapshot.data![index]),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: 0.02.sw),
                    child: CustomWideButton(
                        label: 'Checkout',
                        onTap: (){

                        }
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
}
