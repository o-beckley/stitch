import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/network_services/auth_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
  GlobalKey<FormState> formKey = GlobalKey();
  bool sendingResetMail = false;
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
      backgroundColor: context.watch<UIColors>().surface,
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
            Form(
              key: formKey,
              child: CustomTextField(
                hintText: 'Email',
                controller: emailController,
                validator: (value){
                  //TODO: validate that the email exists in the database
                  String pattern = r"""(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])""";
                  RegExp regex = RegExp(pattern);
                  if (value == null || !regex.hasMatch(value)){
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
            ),
            0.05.sw.verticalSpace,
            CustomWideButton(
              label: 'Continue',
              onTap: sendingResetMail ? null : _sendResetEmail
            ),
          ],
        ),
      ),
    );
  }

  void _sendResetEmail() async {
    setState(() {sendingResetMail = true;});
    if(formKey.currentState!.validate()){
      final resetSent = await context.read<AuthService>()
          .sendPasswordResetEmail(emailController.text);
      if(resetSent && mounted){
        context.pushReplacement(RoutePaths.resetEmailSentScreen);
      }
    }
    setState(() {sendingResetMail = false;});
  }
}
