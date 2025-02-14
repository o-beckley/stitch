import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:go_router/go_router.dart';

class VerticalPicker extends StatefulWidget {
  final String title;
  final List<String> items;
  final List<Widget>? trailingWidgets;
  final Function(int)? onItemPicked;
  final int startingIndex;

  const VerticalPicker({
    required this.title,
    required this.items,
    this.trailingWidgets,
    this.onItemPicked,
    this.startingIndex = 0,
    super.key
  });

  @override
  State<VerticalPicker> createState() => _VerticalPickerState();
}

class _VerticalPickerState extends State<VerticalPicker> {
  late int selectedIndex;

  @override
  void initState(){
    super.initState();
    selectedIndex = widget.startingIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 0.7.sh,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.05.sw),
      ),
      child: Padding(
        padding: EdgeInsets.all(0.05.sw),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.02.sw),
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(
                      widget.items.length,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.015.sw),
                        child: CustomWideButton(
                          label: widget.items[index],
                          color: selectedIndex == index
                            ? context.watch<UIColors>().onPrimaryContainer
                            : context.watch<UIColors>().onSurface,
                          backgroundColor: selectedIndex == index
                            ? context.watch<UIColors>().primary
                            : context.watch<UIColors>().surfaceContainer,
                          trailing: widget.trailingWidgets != null && widget.trailingWidgets!.isNotEmpty
                          ? widget.trailingWidgets![index]
                          : const SizedBox.shrink(),
                          onTap: (){
                            setState(() {
                              selectedIndex = index;
                            });
                            widget.onItemPicked?.call(index);
                            if(context.canPop()){
                              context.pop();
                            }
                          },
                        ),
                      )
                    ),
                  ]
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
