import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/address_form.dart';
import 'package:stitch/widgets/app_bar.dart';


class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    final addresses = context.read<UserManagementService>().currentUser?.addresses;
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.watch<UIColors>().primary,
        child: Icon(
          Icons.add,
          color: context.watch<UIColors>().onPrimaryContainer,
        ),
        onPressed: (){
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(),
            builder: (context){
              return Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: AddressForm(),
              );
            }
          );
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(0.05.sw),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: CustomSliverAppBar(
                title: "Address",
              ),
            ),
            if(addresses != null && addresses.isNotEmpty)
            SliverList.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index){
                return Text(addresses[index].state);
              },
            )
          ],
        ),
      ),
    );
  }
}
