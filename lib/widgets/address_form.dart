import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stitch/models/address_model.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/utils/toasts.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/text_field.dart';

class AddressForm extends StatefulWidget {
  final Address? address;

  const AddressForm({
    this.address,
    super.key
  });

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  //TODO: use some kind of selector instead
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  final FocusNode streetFocus = FocusNode();
  final FocusNode cityFocus = FocusNode();
  final FocusNode stateFocus = FocusNode();
  final FocusNode countryFocus = FocusNode();

  @override void initState(){
    super.initState();
    if(widget.address != null){
      streetController.text = widget.address!.street;
      cityController.text = widget.address!.city;
      stateController.text = widget.address!.state;
      countryController.text = widget.address!.country;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.05.sw)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0.1.sw,
          horizontal: 0.05.sw
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                hintText: "Street address",
                controller: streetController,
                focusNode: streetFocus,
                onEditingComplete: () => FocusScope.of(context).requestFocus(cityFocus),
              ),
              0.02.sw.verticalSpace,
              CustomTextField(
                hintText: "City",
                controller: cityController,
                focusNode: cityFocus,
                onEditingComplete: () => FocusScope.of(context).requestFocus(stateFocus),
              ),
              0.02.sw.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: CustomTextField(
                      hintText: "State",
                      controller: stateController,
                      focusNode: stateFocus,
                      onEditingComplete: () => FocusScope.of(context).requestFocus(countryFocus),
                    ),
                  ),
                  0.02.sw.horizontalSpace,
                  Flexible(
                    child: CustomTextField(
                      hintText: "Country",
                      controller: countryController,
                      focusNode: countryFocus,
                      onEditingComplete: () => FocusScope.of(context).requestFocus(FocusNode()),
                    ),
                  ),
                ],
              ),
              0.05.sw.verticalSpace,
              CustomFilledButton(
                label: widget.address == null ? "Add address" : "Edit address",
                onTap: widget.address == null ? _addAddress : _editAddress,
                disabled: <String>[
                  streetController.text,
                  cityController.text,
                  stateController.text,
                  countryController.text,
                ].any((e) => e.isEmpty)
              )
            ]
          ),
        )
      ),
    );
  }
  void _addAddress() async{
    final userService = context.read<UserManagementService>();
    final addresses = userService.currentUser?.addresses?.toSet() ?? {};
    addresses.add(
      Address(
        street: streetController.text,
        city: cityController.text,
        state: stateController.text,
        country: countryController.text
      )
    );
    final bool successful = await userService.updateProfile(
      addresses: addresses.toList()
    );
    if (mounted && !successful){
      Toasts.showToast("There was a problem adding the address", context);
    }
    if(mounted && context.canPop()){
      context.pop();
    }
  }
  void _editAddress() async {
    if(widget.address != null){
      final userService = context.read<UserManagementService>();
      final addresses = userService.currentUser?.addresses ?? [];
      final indexOfOriginal = addresses.indexOf(widget.address!);
      addresses[indexOfOriginal] = Address(
          street: streetController.text,
          city: cityController.text,
          state: stateController.text,
          country: countryController.text
      );
      final bool successful = await userService.updateProfile(
          addresses: addresses.toSet().toList() // converting to set then lists removes duplicates
      );
      if (mounted && !successful){
        Toasts.showToast("There was a problem editing the address", context);
      }
      if(mounted && context.canPop()){
        context.pop();
      }
    }
  }
}
