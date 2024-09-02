import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/text_field.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String? email;

  const ForgotPasswordScreen({
    this.email,
    super.key
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController emailController;

  @override
  void initState(){
    super.initState();
    emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
        child: ListView(
          children: [
            const CustomAppBar(),
            Text(
              'Forgot Password',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold
              ),
            ),
            0.075.sw.verticalSpace,
            CustomTextField(
              hintText: 'Email',
              controller: emailController,
            ),
            0.05.sw.verticalSpace,
            CustomWideButton(
              label: 'Continue',
              onTap: (){
                // TODO: send reset email from auth service, then:
                context.pushReplacement(RoutePaths.resetEmailSentScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}
