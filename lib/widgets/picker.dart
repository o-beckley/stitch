import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Picker extends StatefulWidget {
  final List<String> items;
  final Function(int)? onItemPicked;

  const Picker({
    required this.items,
    this.onItemPicked,
    super.key
  });

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  int selectedIndex = 0;
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
                padding: EdgeInsets.symmetric(horizontal: radius / 2),
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
                          minWidth: (1.sw / widget.items.length) * 0.85
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
