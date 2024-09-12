import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/network_services/auth_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'package:stitch/utils/router_utils.dart';

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
  GlobalKey<FormState> formKey = GlobalKey();
  bool signingIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
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
            Form(
              key: formKey,
              child: CustomTextField(
                hintText: 'Password',
                controller: passwordController,
                validator: (value){
                  if(value != null && value.isEmpty){
                    return 'Password cannot be empty';
                  }
                  return null;
                },
              ),
            ),
            0.05.sw.verticalSpace,
            CustomWideButton(
              label: 'Continue',
              onTap: signingIn ? null : _signIn
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
  void _signIn () async {
    setState((){signingIn = true;});
    if(formKey.currentState!.validate()){
      final isSuccessful = await context.read<AuthService>()
          .signIn(widget.email, passwordController.text);
      if(isSuccessful && mounted){
        GoRouter.of(context).clearStackAndNavigate(RoutePaths.home);
      }
    }
    setState((){signingIn = false;});
  }
}
