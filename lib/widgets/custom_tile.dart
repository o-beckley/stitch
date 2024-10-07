import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stitch/theme/color_theme.dart';

class CustomTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? hintText;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;


  const CustomTile({
    required this.title,
    this.subtitle,
    this.hintText,
    this.leading,
    this.trailing,
    this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.watch<UIColors>().surfaceContainer,
          borderRadius: BorderRadius.circular(0.02.sw)
        ),
        child: Padding(
          padding: EdgeInsets.all(0.05.sw),
          child: Row(
            children: [
              if(leading != null)
                Padding(
                  padding: EdgeInsets.only(right: 0.05.sw),
                  child: leading,
                ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(hintText != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 0.002.sw),
                        child: Text(
                          hintText!,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: context.watch<UIColors>().outline
                          )
                        ),
                      ),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium
                    ),
                    if(subtitle != null)
                      Padding(
                        padding: EdgeInsets.only(top: 0.002.sw),
                        child: Text(
                          subtitle!,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: context.watch<UIColors>().outline
                          )
                        ),
                      ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              if(trailing != null)
                Padding(
                  padding: EdgeInsets.only(left: 0.05.sw),
                  child: trailing,
                )
            ],
          ),
        ),
      ),
    );
  }
}
