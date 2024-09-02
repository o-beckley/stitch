import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/utils/router_utils.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/text_field.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
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
            ),
            0.05.sw.verticalSpace,
            CustomTextField(
              hintText: 'Last name',
              controller: lastNameController,
              focusNode: lastNameFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(emailFocus),
            ),
            0.05.sw.verticalSpace,
            CustomTextField(
              hintText: 'Email address',
              controller: emailController,
              focusNode: emailFocus,
              onEditingComplete: () => FocusScope.of(context).requestFocus(passwordFocus),
            ),
            0.05.sw.verticalSpace,
            CustomTextField(
              hintText: 'Password',
              controller: passwordController,
              focusNode: passwordFocus,
              obscureText: true,
            ),
            0.075.sw.verticalSpace,
            CustomWideButton(
              label: 'Continue',
              onTap: (){
                // TODO: create an account, then:
                GoRouter.of(context).clearStackAndNavigate(RoutePaths.setPreferencesScreen);
              },
            )
          ]
        ),
      )
    );
  }
}
