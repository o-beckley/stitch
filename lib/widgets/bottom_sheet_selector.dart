import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/vertical_picker.dart';

class BottomSheetSelector extends StatefulWidget {
  final String label;
  final List<String> items;
  final Function(int)? onItemSelected;

  const BottomSheetSelector({
    required this.label,
    required this.items,
    this.onItemSelected,
    super.key
  });

  @override
  State<BottomSheetSelector> createState() => _BottomSheetSelectorState();
}

class _BottomSheetSelectorState extends State<BottomSheetSelector> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CustomWideButton(
        label: selectedIndex == null
        ? widget.label
        : widget.items[selectedIndex!],
        backgroundColor: context.watch<UIColors>().surfaceContainer,
        color: selectedIndex == null
        ? context.watch<UIColors>().outline
        : context.watch<UIColors>().onSurface,
        trailing: SvgPicture.asset(
          AssetPaths.arrowDownIcon,
          colorFilter: ColorFilter.mode(
              context.watch<UIColors>().onSurface,
              BlendMode.srcIn
          ),
        ),
        onTap: (){
          showModalBottomSheet(
            context: context,
            builder: (context){
              return VerticalPicker(
                title: widget.label,
                items: widget.items,
                onItemPicked: (index){
                  setState(() {
                    selectedIndex = index;
                  });
                  widget.onItemSelected?.call(index);
                },
              );
            }
          );
        },
      ),
    );
  }
}
