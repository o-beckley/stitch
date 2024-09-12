import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final List<Widget>? trailingWidgets;
  final bool displayTrailingOnButton;

  const BottomSheetSelector({
    required this.label,
    required this.items,
    this.onItemSelected,
    this.trailingWidgets,
    this.displayTrailingOnButton = false,
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
        label: widget.label,
        backgroundColor: context.watch<UIColors>().surfaceContainer,
        color: context.watch<UIColors>().outline,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(selectedIndex != null)
              Padding(
                padding: EdgeInsets.only(right: 0.1.sw),
                child: widget.displayTrailingOnButton && widget.trailingWidgets != null && widget.trailingWidgets!.isNotEmpty
                ? widget.trailingWidgets![selectedIndex!]
                : Text(
                  widget.items[selectedIndex!],
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
            SvgPicture.asset(
              AssetPaths.arrowDownIcon,
              colorFilter: ColorFilter.mode(
                  context.watch<UIColors>().onSurface,
                  BlendMode.srcIn
              ),
            ),
          ],
        ),
        onTap: (){
          showModalBottomSheet(
            context: context,
            builder: (context){
              return VerticalPicker(
                title: widget.label,
                items: widget.items,
                trailingWidgets: widget.trailingWidgets,
                startingIndex: selectedIndex ?? 0,
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
