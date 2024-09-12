import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:provider/provider.dart';
import 'package:stitch/theme/color_theme.dart';

class CustomDropDownMenu extends StatefulWidget {
  final String? label;
  final List<String> items;
  final Function(int)? onItemSelected;
  final bool isExpanded;

  const CustomDropDownMenu({
    this.label,
    required this.items,
    this.onItemSelected,
    this.isExpanded = false,
    super.key
  });

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  late int selectedIndex;
  late List<String> items;
  @override
  void initState(){
    super.initState();
    selectedIndex = widget.label != null ? -1 : 0;
    if(widget.label != null){
      items = [widget.label!, ...widget.items];
    }
    else{
      items = widget.items;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _HelperWidgetThingy(
      isExpanded: widget.isExpanded,
      child: Container(
        decoration: BoxDecoration(
          color: context.watch<UIColors>().surfaceContainer,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: DropdownButton<int>(
            value: selectedIndex,
            isExpanded: widget.isExpanded,
            isDense: true,
            underline: const SizedBox.shrink(),
            icon: SvgPicture.asset(
              AssetPaths.arrowDownIcon,
              colorFilter: ColorFilter.mode(
                context.watch<UIColors>().onSurface,
                BlendMode.srcIn
              ),
            ),
            items: List.generate(
              items.length,
              (index){
                return DropdownMenuItem(
                  enabled: !(widget.label != null && index == 0),
                  value: widget.label != null ? index - 1 : index,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                        items[index],
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: !(widget.label != null && index == 0)
                          ? context.watch<UIColors>().onSurface
                          : context.watch<UIColors>().outline
                      ),
                    ),
                  ),
                );
              }
            ),
            onChanged: (int? index){
              if(index is int){
                setState(() {
                  selectedIndex = index;
                });
                widget.onItemSelected?.call(index);
              }
            }
          ),
        ),
      ),
    );
  }
}

class _HelperWidgetThingy extends StatelessWidget {
  final Widget child;
  final bool isExpanded;

  const _HelperWidgetThingy({
    required this.child,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    if(isExpanded){
      return child;
    }
    else{
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [child],
      );
    }
  }
}
