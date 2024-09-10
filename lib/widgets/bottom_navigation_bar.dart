import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stitch/theme/color_theme.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final List<String> iconPaths;
  final Function(int)? onTap;

  const CustomBottomNavigationBar({
    required this.iconPaths,
    this.onTap,
    super.key
  });

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.watch<UIColors>().surfaceContainer
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 0.02.sh, top: 0.01.sh),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            widget.iconPaths.length,
              (index){
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedIndex = index;
                    });
                    widget.onTap?.call(index);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(0.035.sh),
                    child: SizedBox.square(
                      dimension: 0.035.sh,
                      child: SvgPicture.asset(
                        widget.iconPaths[index],
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          selectedIndex == index
                          ? context.watch<UIColors>().primary
                          : context.watch<UIColors>().onSurface.withOpacity(0.5),
                          BlendMode.srcIn
                        ),
                      ),
                    ),
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
}
