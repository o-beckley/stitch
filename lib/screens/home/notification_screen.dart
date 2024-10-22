import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:stitch/models/notification_model.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/custom_tile.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<UserManagementService>().currentUser?.notifications;
    if(notifications?.isNotEmpty ?? false) {
      return Scaffold(backgroundColor: context.watch<UIColors>().surface,
        body: Padding(
          padding: EdgeInsets.all(0.05.sw),
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                delegate: CustomSliverAppBar(
                  title: "Notifications",
                  hasBackButton: false,
                ),
              ),
              if(notifications != null)
                SliverList.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 0.02.sw),
                      child: _NotificationTile(
                          notification: notifications[index]),
                    );
                  },
                ),
            ],
          ),
        ),
      );
    }
    else{
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AssetPaths.bellImage),
              0.05.sw.verticalSpace,
              Text(
                "No notifications yet",
                style: Theme.of(context).textTheme.headlineMedium
              ),
            ],
          ),
        ),
      );
    }
  }
}

class _NotificationTile extends StatelessWidget {
  final StitchNotification notification;

  const _NotificationTile({
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTile(
      title: notification.title,
      subtitle: notification.body,
      onTap: (){
        // TODO: expand the notification.
      },
      leading: SvgPicture.asset(
        AssetPaths.notificationIcon,
        colorFilter: ColorFilter.mode(
          context.watch<UIColors>().onSurface,
          BlendMode.srcIn
        ),
      ),
      trailing: notification.isRead
      ? null
      : SizedBox.square(
        dimension: 5,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(2.5)
          ),
        ),
      ),
    );
  }
}
