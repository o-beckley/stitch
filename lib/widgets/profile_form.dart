import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/utils/toasts.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/text_field.dart';

class ProfileForm extends StatefulWidget {

  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();

  @override void initState(){
    super.initState();
    final currentUser = context.read<UserManagementService>().currentUser;
    if(currentUser != null){
      emailController.text = currentUser.email ?? "";
      phoneController.text = currentUser.phoneNumber ?? "";
      firstNameController.text = currentUser.firstName ?? "";
      lastNameController.text = currentUser.lastName ?? "";
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: CustomTextField(
                          hintText: "First name",
                          controller: firstNameController,
                          focusNode: firstNameFocus,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(lastNameFocus),
                        ),
                      ),
                      0.02.sw.horizontalSpace,
                      Flexible(
                        child: CustomTextField(
                          hintText: "Last name",
                          controller: lastNameController,
                          focusNode: lastNameFocus,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(emailFocus),
                        ),
                      ),
                    ],
                  ),
                  0.02.sw.verticalSpace,
                  CustomTextField(
                    hintText: "Email",
                    controller: emailController,
                    focusNode: emailFocus,
                    onEditingComplete: () => FocusScope.of(context).requestFocus(phoneFocus),
                  ),
                  0.02.sw.verticalSpace,
                  CustomTextField(
                    hintText: "Phone",
                    controller: phoneController,
                    focusNode: phoneFocus,
                    onEditingComplete: () => FocusScope.of(context).requestFocus(FocusNode()),
                  ),
                  0.05.sw.verticalSpace,
                  CustomFilledButton(
                      label: "Edit profile",
                      onTap: _editProfile,
                      disabled: <String>[
                        emailController.text,
                        phoneController.text,
                        firstNameController.text,
                        lastNameController.text,
                      ].any((e) => e.isEmpty)
                  )
                ]
            ),
          )
      ),
    );
  }
  void _editProfile() async {
    final userService = context.read<UserManagementService>();
    final bool successful = await userService.updateProfile(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      phoneNumber: phoneController.text,
    );
    if (mounted && !successful){
      Toasts.showToast("There was a problem editing your profile", context);
    }
    if(mounted && context.canPop()){
      context.pop();
    }
  }
}
