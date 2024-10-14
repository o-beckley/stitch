import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/models/address_model.dart';
import 'package:stitch/models/delivery_details_model.dart';
import 'package:stitch/models/order_item_model.dart';
import 'package:stitch/network_services/product_provider_service.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/utils/toasts.dart';
import 'package:stitch/utils/validate.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/custom_tile.dart';
import 'package:stitch/widgets/loading_indicator.dart';
import 'package:stitch/widgets/placeholders.dart';
import 'package:stitch/widgets/text_field.dart';

class CheckoutScreen extends StatefulWidget {
  final List<OrderItem> orderItems;

  const CheckoutScreen({
    required this.orderItems,
    super.key
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool checkingOut = false;
  GlobalKey<FormState> phoneNumberFormKey = GlobalKey();
  late Future<double?> subtotal;
  late Future<double?> totalDeliveryFees;
  late TextEditingController phoneNumberController;
  Address? selectedAddress;

  @override
  void initState(){
    super.initState();
    subtotal = getSubtotal(widget.orderItems);
    totalDeliveryFees = getDeliveryFees(widget.orderItems);
    phoneNumberController = TextEditingController(
      text: context.read<UserManagementService>().currentUser?.phoneNumber
    );
  }

  @override
  void dispose(){
    phoneNumberController.dispose();
    super.dispose();
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
                    delegate: CustomSliverAppBar(
                        title: 'Checkout'
                    ),
                  ),
                  if(selectedAddress != null)
                  SliverToBoxAdapter(
                    child: CustomTile(
                      title: "${selectedAddress!.street}, ${selectedAddress!.city}",
                      subtitle: "${selectedAddress!.state}, ${selectedAddress!.country}",
                      trailing: CustomSvgIconButton(svgIconPath: AssetPaths.arrowDownIcon),
                      onTap: (){
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(),
                          builder: (context){
                            return _AddressList(
                              onAddressSelected: (address){
                                setState(() {
                                  selectedAddress = address;
                                });
                              }
                            );
                          }
                        );
                      },
                    )
                  )
                  else
                  SliverToBoxAdapter(
                    child: CustomTile(
                      hintText: "Delivery address",
                      title: "Select a delivery address",
                      trailing: CustomSvgIconButton(svgIconPath: AssetPaths.arrowDownIcon),
                      onTap: (){
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(),
                          builder: (context){
                            return _AddressList(
                              onAddressSelected: (address){
                                setState(() {
                                  selectedAddress = address;
                                });
                              }
                            );
                          }
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(child: 0.05.sw.verticalSpace),
                  SliverToBoxAdapter(
                    child: Form(
                      key: phoneNumberFormKey,
                      child: CustomTextField(
                        hintText: "Phone number",
                        controller: phoneNumberController,
                        validator: (value){
                          if(!Validate.phoneNumber(value)){
                            return "Enter a valid phone number";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: 0.05.sw.verticalSpace),
                  SliverToBoxAdapter(
                    child: CustomTile(
                      hintText: "Payment method",
                      title: "Select a payment method",
                      trailing: CustomSvgIconButton(svgIconPath: AssetPaths.arrowDownIcon),
                      onTap: (){
                        // TODO: show a modal bottom sheet to pick a payout method or add a new one
                      },
                    ),
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
                  FutureBuilder(
                    future: Future.wait([subtotal, totalDeliveryFees]),
                    builder: (context, snapshot) {
                      if(snapshot.data != null && snapshot.data!.every((e) => e != null)){
                        return Hero(
                          tag: "checkout_place_order_buttons",
                          child: CustomWideButton(
                            label: "Place order",
                              disabled: checkingOut,
                              trailing: Text(
                                '\$${snapshot.data![0]! + snapshot.data![1]!}', //TODO: handle currency
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: context.watch<UIColors>().onPrimaryContainer.withOpacity(0.5)
                                ),
                              ),
                            onTap: _placeOrder
                          ),
                        );
                      }
                      else{
                        return SizedBox.square(
                          dimension: 0.05.sw,
                          child: const LoadingIndicator(),
                        );
                      }
                    }
                  ),
                ],
              ),
            )
          ],
        )
      )
    );
  }

  void _placeOrder() async {
    if(selectedAddress != null && phoneNumberFormKey.currentState!.validate()){
      setState(() {
        checkingOut = true;
      });
      final bool successful = await context.read<UserManagementService>().checkout(
        orderItems: widget.orderItems,
        deliveryDetails: DeliveryDetails(
          address: selectedAddress!,
          phoneNumber: phoneNumberController.text
        ),
      );
      setState(() {
        checkingOut = false;
      });
      if(successful && mounted){
        context.push(RoutePaths.orderSuccessScreen);
      }
      else if (mounted){
        Toasts.showToast("Something went wrong, please try again later.", context);
      }
    }
    else{
      Toasts.showToast("select a payment method and delivery details", context);
    }
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
}


class _AddressList extends StatelessWidget {
  final ValueChanged<Address> onAddressSelected;

  const _AddressList({
    required this.onAddressSelected,
  });

  @override
  Widget build(BuildContext context) {
    final addresses = context.read<UserManagementService>().currentUser?.addresses;
    if(addresses != null && addresses.isNotEmpty){
      return Padding(
        padding: EdgeInsets.all(0.05.sw),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            addresses.length,
            (index){
              return CustomTile(
                title: "${addresses[index].street}, ${addresses[index].city}",
                subtitle: "${addresses[index].state}, ${addresses[index].country}",
                onTap: (){
                  onAddressSelected(addresses[index]);
                  if(context.canPop()){
                    context.pop();
                  }
                },
              );
            }
          )
        ),
      );
    }
    return const Placeholder();
  }
}
