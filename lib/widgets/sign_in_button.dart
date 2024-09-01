
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stitch/theme/color_theme.dart';

class SignInButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback? onTap;
  final bool disabled;

  const SignInButton({
    required this.label,
    required this.iconPath,
    this.onTap,
    this.disabled = false,
    super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: SizedBox(
        height: 50,
        child: Opacity(
          opacity: disabled ? 0.32 : 1,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: context.watch<UIColors>().surfaceContainer
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.5,
                    vertical: 10
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox.square(
                        dimension: 40,
                        child: SvgPicture.asset(iconPath)
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Center(
                          child: Text(
                            label,
                            style: Theme.of(context).textTheme.labelLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    40.horizontalSpace // this is to match the width of the icon so that the label is centralized
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
}
