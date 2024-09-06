import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/network_services/auth_service.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/utils/router_utils.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/text_field.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool creatingAccount = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const CustomAppBar(),
              Text(
                'Create Account',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold
                ),
              ),
              0.075.sw.verticalSpace,
              CustomTextField(
                hintText: 'First name',
                controller: firstNameController,
                // focusNode: firstNameFocus,
                onEditingComplete: () => FocusScope.of(context).requestFocus(lastNameFocus),
                validator: (value){
                  if(value != null && value.length < 3){
                    return 'Enter a valid name';
                  }
                  else {
                    return null;
                  }
                },
              ),
              0.05.sw.verticalSpace,
              CustomTextField(
                hintText: 'Last name',
                controller: lastNameController,
                focusNode: lastNameFocus,
                onEditingComplete: () => FocusScope.of(context).requestFocus(emailFocus),
                validator: (value){
                  if(value != null && value.length < 3){
                    return 'Enter a valid name';
                  }
                  else {
                    return null;
                  }
                },
              ),
              0.05.sw.verticalSpace,
              CustomTextField(
                hintText: 'Email address',
                controller: emailController,
                focusNode: emailFocus,
                onEditingComplete: () => FocusScope.of(context).requestFocus(passwordFocus),
                validator: (value){
                  String pattern = r"""(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])""";
                  RegExp regex = RegExp(pattern);
                  if (value == null || !regex.hasMatch(value)){
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              0.05.sw.verticalSpace,
              CustomTextField(
                hintText: 'Password',
                controller: passwordController,
                focusNode: passwordFocus,
                obscureText: true,
                validator: (value){
                  if(value != null && value.length < 8){
                    return 'Use at least 8 characters';
                  }
                  return null;
                },
              ),
              0.075.sw.verticalSpace,
              CustomWideButton(
                label: 'Continue',
                onTap: creatingAccount ? null : _createAccount
              )
            ]
          ),
        ),
      )
    );
  }
  void _createAccount () async {
    setState(() {creatingAccount = true;});
    if (formKey.currentState!.validate()){
      final isSuccessful = await context.read<AuthService>()
          .createAccount(emailController.text, passwordController.text);
      if(isSuccessful && mounted){
        await context.read<UserManagementService>().updateProfile(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
        );
        if(mounted) {
          GoRouter.of(context).clearStackAndNavigate(
              RoutePaths.setPreferencesScreen);
        }
      }
    }
    setState(() {creatingAccount = false;});
  }
}
