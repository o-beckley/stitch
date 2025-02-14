import 'package:flutter/material.dart';
import 'package:stitch/config/asset_paths.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/network_services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/utils/validate.dart';
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
      backgroundColor: context.watch<UIColors>().surface,
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
                  if (value == null || !Validate.email(value)){
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
    final userService = context.read<UserManagementService>();
    setState(() {
      isSigningIn = true;
    });
    bool signedIn = await auth.signInWithGoogle();
    final hasProfile = await userService.hasProfile;
    if(signedIn){
      if(!hasProfile){
        await userService.updateProfile(
          firstName: _splitName(userService.user?.displayName)[0],
          lastName: _splitName(userService.user?.displayName)[1],
          email: userService.user?.email,
          phoneNumber: userService.user?.phoneNumber,
        );
        if(mounted){
          context.pushReplacement(RoutePaths.setPreferencesScreen);
        }
      }
      else if(mounted){
        context.pushReplacement(RoutePaths.home);
      }
    }
    else {
      setState(() {
        isSigningIn = false;
      });
    }
  }

  List<String?> _splitName(String? joinedName){
    if(joinedName == null){
      return [null, null];
    }
    else if(joinedName.split(' ').length > 1){
      List<String> split = joinedName.split(' ');
      return [split.first, split.last];
    }
    else{
      return [joinedName, null];
    }
  }
}
