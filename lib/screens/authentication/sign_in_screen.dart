import 'package:flutter/material.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/network_services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/sign_in_button.dart';
import 'package:stitch/widgets/text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isSigningIn = false;
  GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController emailController;

  @override
  void initState(){
    super.initState();
    emailController = TextEditingController();
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
            const CustomAppBar(hasBackButton: false,),
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
                hintText: 'Email Address',
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
              onTap: (){
                if(formKey.currentState!.validate()){
                  context.push(RoutePaths.passwordScreen, extra: {'email': emailController.text});
                }
              },
            ),
            0.01.sw.verticalSpace,
            Row(
              children: [
                const Text('Don\'t have an account?'),
                CustomTextButton(
                  label: 'Create one',
                  onTap: (){
                    context.push(RoutePaths.createAccountScreen);
                  },
                )
              ],
            ),
            0.1.sw.verticalSpace,
            SignInButton(
              label: 'Continue with Google',
              iconPath: AssetPaths.googleIcon,
              onTap: _googleSignIn,
              disabled: isSigningIn,
            ),
            0.025.sw.verticalSpace,
            SignInButton(
              label: 'Continue with Apple',
              iconPath: context.watch<UIColors>().darkMode.value
                ? AssetPaths.appleLightIcon : AssetPaths.appleDarkIcon,
              disabled: true,
            ),
            0.025.sw.verticalSpace,
            const SignInButton(
              label: 'Continue with Facebook',
              iconPath: AssetPaths.facebookIcon,
              disabled: true,
            ),
          ],
        ),
      ),
    );
  }

  void _googleSignIn () async {
    final auth = context.read<AuthService>();
    setState(() {
      isSigningIn = true;
    });
    bool signedIn = await auth.signInWithGoogle();
    if(signedIn && mounted){
      context.pushReplacement(RoutePaths.home);
    }
    else {
      setState(() {
        isSigningIn = false;
      });
    }
  }
}
