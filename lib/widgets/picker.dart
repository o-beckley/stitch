import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Picker extends StatefulWidget {
  final List<String> items;
  final Function(int)? onItemPicked;
  final int startingIndex;

  const Picker({
    required this.items,
    this.onItemPicked,
    this.startingIndex = 0,
    super.key
  });

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  late int selectedIndex;

  @override
  void initState(){
    super.initState();
    selectedIndex = widget.startingIndex;
  }

  @override
  Widget build(BuildContext context) {
    double radius = math.max(20, 50 / widget.items.length);
    return SizedBox(
      height: 2 * radius,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            widget.items.length,
            (index){
              return  Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 0 : radius / 2,
                  right: index == widget.items.length ? radius / 2 : 0
                ),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedIndex = index;
                    });
                    widget.onItemPicked?.call(index);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          minWidth: (0.9.sw / widget.items.length) - radius / 2
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          color: index == selectedIndex
                          ? context.watch<UIColors>().primary
                          : context.watch<UIColors>().surfaceContainer
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: radius),
                          child: Center(
                            child: Text(
                              widget.items[index],
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: index == selectedIndex
                                ? context.watch<UIColors>().onPrimaryContainer
                                : context.watch<UIColors>().onSurface
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          )
        ),
      ),
    );
  }
}
