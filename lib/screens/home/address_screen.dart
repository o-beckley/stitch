import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stitch/models/address_model.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/utils/toasts.dart';
import 'package:stitch/widgets/address_form.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/custom_tile.dart';


class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    final addresses = context.watch<UserManagementService>().currentUser?.addresses;
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.watch<UIColors>().primary,
        onPressed: _showAddressForm,
        child: Icon(
          Icons.add,
          color: context.watch<UIColors>().onPrimaryContainer,
        ),
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
                final address = addresses[index];
                return Padding(
                  padding: EdgeInsets.only(top: 0.025.sw),
                  child: Dismissible(
                    key: ValueKey(address),
                    onDismissed: (direction){
                      _removeAddress(address);
                    },
                    direction: DismissDirection.endToStart,
                    background: Container(
                        color: context.watch<UIColors>().error.withOpacity(0.32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 0.05.sw),
                              child: Icon(Icons.delete),
                            ),
                          ],
                        )
                    ),
                    child: CustomTile(
                      title: "${address.street}, ${address.city}\n${address.state}, ${address.country}",
                      trailing: CustomTextButton(
                        label: "Edit",
                        color: context.watch<UIColors>().primary,
                        onTap: (){
                          _showAddressForm(address);
                        },
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
  void _showAddressForm([Address? address]){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(),
        builder: (context){
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: AddressForm(address: address),
          );
        }
    );
  }
  void _removeAddress(Address address) async {
    final userService = context.read<UserManagementService>();
    final addresses = userService.currentUser?.addresses ?? [];
    addresses.remove(address);
    final bool successful = await userService.updateProfile(
        addresses: addresses.toSet().toList() // converting to set then lists removes duplicates
    );
    if (mounted && !successful){
      Toasts.showToast("There was a problem removing the address", context);
    }
  }
}
