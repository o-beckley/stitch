import 'package:flutter/material.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/network_services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/theme/color_theme.dart';
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
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
          child: ListView(
            children: [
              0.2.sw.verticalSpace,

              Text(
                'Sign in',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold
                ),
              ),

              0.1.sw.verticalSpace,

              CustomTextField(
                hintText: 'Email Address',
                controller: emailController,
              ),
              0.05.sw.verticalSpace,
              CustomWideButton(
                label: 'Continue',
                onTap: (){},
              ),

              0.15.sw.verticalSpace,

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
                disabled: true && isSigningIn,
              ),
              0.025.sw.verticalSpace,
              SignInButton(
                label: 'Continue with Facebook',
                iconPath: AssetPaths.facebookIcon,
                disabled: true && isSigningIn,
              ),
            ],
          ),
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
