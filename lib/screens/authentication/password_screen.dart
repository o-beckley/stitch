import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/text_field.dart';

class PasswordScreen extends StatefulWidget {
  final String email;
  const PasswordScreen({
    required this.email,
    super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
        child: ListView(
          children: [
            const CustomAppBar(hasBackButton: false),
            Text(
              'Sign in',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold
              ),
            ),
            0.075.sw.verticalSpace,
            CustomTextField(
              hintText: 'Password',
              controller: passwordController,
            ),
            0.05.sw.verticalSpace,
            CustomWideButton(
              label: 'Continue',
              onTap: (){

              },
            ),
            0.01.sw.verticalSpace,
            Row(
              children: [
                const Text('Forgot password?'),
                CustomTextButton(
                  label: 'Reset',
                  onTap: (){
                    context.push(RoutePaths.forgotPasswordScreen, extra: {'email': widget.email});
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
