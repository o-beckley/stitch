import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/theme/color_theme.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onClear;

  const CustomSearchBar({
    this.controller,
    this.focusNode,
    this.onTap,
    this.onEditingComplete,
    this.onClear,
    super.key
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late FocusNode? focusNode;

  @override
  void initState(){
    super.initState();
    focusNode = widget.focusNode == null ? FocusNode() : null;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.focusNode != null){
          if(!widget.focusNode!.hasFocus) {
            FocusScope.of(context).requestFocus(widget.focusNode);
          }
        }
        else if(focusNode != null && !focusNode!.hasFocus){
          FocusScope.of(context).requestFocus(focusNode);
        }
        widget.onTap?.call();
      },
      child: SizedBox(
        height: 40,
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: context.watch<UIColors>().surfaceContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AssetPaths.searchIcon,
                  colorFilter: ColorFilter.mode(
                    widget.controller?.text.isNotEmpty ?? false
                      ? context.watch<UIColors>().onSurface
                      : context.watch<UIColors>().outline,
                    BlendMode.srcIn
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    controller: widget.controller,
                    enabled: widget.controller != null,
                    focusNode: widget.focusNode ?? focusNode,
                    cursorColor: context.watch<UIColors>().outline,
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: context.watch<UIColors>().outline
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        bottom: 9
                      ),
                    ),
                    onChanged: (value){
                      setState(() {});
                    },
                    onEditingComplete: (){
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.onEditingComplete?.call();
                    },
                    onTapOutside: (_) => FocusScope.of(context).requestFocus(FocusNode())
                  ),
                ),
                if(widget.controller?.text.isNotEmpty ?? false)
                GestureDetector(
                  onTap:(){
                    setState(() {
                      widget.controller?.clear();
                    });
                    widget.onClear?.call();
                  },
                  child: SvgPicture.asset(
                    AssetPaths.xIcon,
                    colorFilter: ColorFilter.mode(
                      context.watch<UIColors>().outline,
                      BlendMode.srcIn
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}