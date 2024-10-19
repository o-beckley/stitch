import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/custom_search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();

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
                focusNode: searchFocus
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TopSearchArea extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _TopSearchArea({
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SliverTopSearchArea extends SliverPersistentHeaderDelegate{
  final TextEditingController controller;
  final FocusNode focusNode;

  _SliverTopSearchArea({
    required this.controller,
    required this.focusNode
  });

  @override
  double get maxExtent => 0.4.sw;

  @override
  double get minExtent => 0.4.sw;

  @override
  bool shouldRebuild(_SliverTopSearchArea oldDelegate) => false; // TODO: ?

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _TopSearchArea(
      controller: controller,
      focusNode: focusNode
    );
  }
}