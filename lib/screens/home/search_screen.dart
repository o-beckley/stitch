import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/models/product_model.dart';
import 'package:stitch/network_services/product_provider_service.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/custom_search_bar.dart';
import 'package:stitch/widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  QueryDocumentSnapshot<Product>? lastQuerySnapshot;
  String lastQuery = "";
  List<Product> products = [];
  
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await Future.delayed(const Duration(milliseconds: 500));
        if(mounted){
          FocusScope.of(context).requestFocus(searchFocus);
        }
      }
    );
  }
  
  Future<void> search() async {
    if(searchController.text != lastQuery){
      clearSearch();
    }
    final productService = context.read<ProductProviderService>();
    final result = await productService.search(
      searchController.text,
      lastQuerySnapshot: lastQuerySnapshot
    );
    if(result != null && result.docs.isNotEmpty){
      lastQuerySnapshot = result.docs.last;
      setState(() {
        products.addAll(result.docs.map((e) => e.data()));
      });
    }
  }
  
  void clearSearch() async {
    setState(() {
      lastQuerySnapshot = null;
      lastQuery = "";
      products = [];
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(0.05.sw),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: _SliverTopSearchArea(
                controller: searchController,
                focusNode: searchFocus,
                onEditingComplete: (){
                  search();
                },
                onClear: (){
                  clearSearch();
                }
              ),
            ),
            SliverGrid.builder(
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                childAspectRatio: 4/7
              ),
              itemBuilder: (context, index){
                return Center(
                  child: ProductCard(product: products[index])
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverTopSearchArea extends SliverPersistentHeaderDelegate{
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onClear;

  _SliverTopSearchArea({
    required this.controller,
    required this.focusNode,
    this.onEditingComplete,
    this.onClear,
  });

  @override
  double get maxExtent => 0.2.sw;

  @override
  double get minExtent => 0.2.sw;

  @override
  bool shouldRebuild(_SliverTopSearchArea oldDelegate) => false; // TODO: ?

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Row(
          children: [
            CustomSvgIconButton(
              svgIconPath: AssetPaths.arrowBackIcon,
              onTap: (){
                if(context.canPop()){
                  context.pop();
                }
              },
            ),
            0.025.sw.horizontalSpace,
            Flexible(
              child: Hero(
                tag: "search_bar",
                child: CustomSearchBar(
                  controller: controller,
                  focusNode: focusNode,
                  onEditingComplete: onEditingComplete,
                  onClear: onClear,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}