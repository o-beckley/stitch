import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/models/product_model.dart';
import 'package:stitch/network_services/product_provider_service.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitch/widgets/custom_search_bar.dart';
import 'package:stitch/widgets/drop_down_menu.dart';
import 'package:stitch/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  QueryDocumentSnapshot? lastSnapshot;
  List<Product> products = [];
  late Gender selectedGender;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserManagementService>().currentUser;
    selectedGender = user?.gender ?? Gender.male;
    getProducts(selectedGender);
  }

  Future<void> getProducts(Gender gender) async {
    final productService = context.read<ProductProviderService>();
    final snapshots = await productService.getProducts(
      gender: gender,
      lastQuerySnapshot: lastSnapshot
    );
    if (snapshots != null && snapshots.docs.isNotEmpty){
      lastSnapshot = snapshots.docs.last;
      setState(() {
        products.addAll(snapshots.docs.map((e) => e.data()));
      });
    }
  }

  void clearProducts(){
    lastSnapshot = null;
    setState(() {
      products = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
      body: Padding(
        padding: EdgeInsets.all(0.05.sw),
        child: Center(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: 0.1.sw.verticalSpace),
              SliverPersistentHeader(
                delegate: _HomeAppBar(
                  onGenderChanged: (int index){
                    clearProducts();
                    getProducts(Gender.values[index]);
                  }
                )
              ),
              SliverToBoxAdapter(child: 0.05.sw.verticalSpace),
              if(products.isNotEmpty)
                SliverGrid.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4/7,
                  ),
                  itemBuilder: (context, index){
                    return Center(
                      child: ProductCard(
                        product: products[index]
                      ),
                    );
                  },
                )
              else
                SliverGrid.builder(
                  itemCount: 2,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4/7,
                  ),
                  itemBuilder: (context, index){
                    return Center(
                      child: ProductCardLoading(),
                    );
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeAppBar extends SliverPersistentHeaderDelegate{
  final ValueChanged<int>? onGenderChanged;

  _HomeAppBar({
    this.onGenderChanged,
  });

  @override
  double get maxExtent => 41 + 0.05.sw + 40;

  @override
  double get minExtent => 41 + 0.05.sw + 40;

  @override
  bool shouldRebuild(_HomeAppBar oldDelegate) => false;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent){
    final user = context.watch<UserManagementService>().currentUser;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomDropDownMenu(
              items: Gender.values.map((e) => e.name).toList(),
              initialIndex: Gender.values.indexOf(user?.gender ?? Gender.male),
              onItemSelected: onGenderChanged
            ),
            CustomSvgIconButton(
              svgIconPath: AssetPaths.bagIcon,
              backgroundColor: context.watch<UIColors>().primary,
              iconColor: context.watch<UIColors>().onPrimaryContainer,
              onTap: (){
                context.push(RoutePaths.cartScreen);
              },
            ),
          ],
        ),
        0.05.sw.verticalSpace,
        Hero(
          tag: "search_bar",
          child: CustomSearchBar(
            onTap: (){
              context.push(RoutePaths.searchScreen);
            },
          ),
        ),
      ],
    );
  }
}