import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/models/order_item_model.dart';
import 'package:stitch/models/order_model.dart';
import 'package:stitch/models/product_model.dart';
import 'package:stitch/screens/authentication/create_account_screen.dart';
import 'package:stitch/screens/authentication/forgot_password_screen.dart';
import 'package:stitch/screens/authentication/password_screen.dart';
import 'package:stitch/screens/authentication/reset_email_sent_screen.dart';
import 'package:stitch/screens/authentication/set_preferences_screen.dart';
import 'package:stitch/screens/authentication/sign_in_screen.dart';
import 'package:stitch/screens/authentication/splash_screen.dart';
import 'package:stitch/screens/home/address_screen.dart';
import 'package:stitch/screens/home/cart_screen.dart';
import 'package:stitch/screens/home/checkout_screen.dart';
import 'package:stitch/screens/home/home.dart';
import 'package:stitch/screens/home/order_details_screen.dart';
import 'package:stitch/screens/home/order_success_screen.dart';
import 'package:stitch/screens/home/payment_screen.dart';
import 'package:stitch/screens/home/product_screen.dart';
import 'package:stitch/screens/home/search_screen.dart';

final GoRouter routerConfig = GoRouter( // TODO: add routing animations
  initialLocation: RoutePaths.splashScreen,
  errorBuilder: (context, state) => const ErrorBuilder(),
  routes: [
    GoRoute(
      path: RoutePaths.addressScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const AddressScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.cartScreen,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
            child: const CartScreen(),
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 400),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (context, animation, _, child){
              return SlideTransition(
                position: animation.drive(CurveTween(curve: Curves.easeIn)).drive(
                  Tween<Offset>(
                      begin: Offset(1, -1),
                      end: Offset(0, 0)
                  ),
                ),
                child: child,
              );
            }
        );
      }
    ),
    GoRoute(
        path: RoutePaths.checkoutScreen,
        pageBuilder: (context, state){
          final orderItems = state.extra as List<OrderItem>?;
          if(orderItems != null){
            return CupertinoPage(
                child: CheckoutScreen(orderItems: orderItems),
                key: state.pageKey
            );
          }
          return CupertinoPage(
              child: const ErrorBuilder(message: 'The List of order items was not passed while navigating to the checkout screen',),
              key: state.pageKey
          );
        }
    ),
    GoRoute(
      path: RoutePaths.createAccountScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const CreateAccountScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.forgotPasswordScreen,
      pageBuilder: (context, state){
        final data = state.extra as Map<String, String>?;
        final email = data?['email'];
        return CupertinoPage(
          child: ForgotPasswordScreen(email: email),
          key: state.pageKey
        );
      }
    ),
    GoRoute(
      path: RoutePaths.home,
      pageBuilder: (context, state) => CupertinoPage(
        child: const Home(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.orderDetailsScreen,
      pageBuilder: (context, state){
        final order = state.extra as StitchOrder?;
        if(order != null){
          return CupertinoPage(
              child: OrderDetailsScreen(order: order),
              key: state.pageKey
          );
        }
        return CupertinoPage(
            child: const ErrorBuilder(message: 'The order was not passed while navigating to the order details screen',),
            key: state.pageKey
        );
      }
    ),
    GoRoute(
      path: RoutePaths.orderSuccessScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const OrderSuccessScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.passwordScreen,
      pageBuilder: (context, state){
        final data = state.extra as Map<String, String>?;
        final email = data?['email'];
        if(email != null){
          return CupertinoPage(
              child: PasswordScreen(email: email),
              key: state.pageKey
          );
        }
        return CupertinoPage(
          child: const ErrorBuilder(message: 'The email was not passed while navigating to the password screen',),
          key: state.pageKey
        );
      }
    ),
    GoRoute(
      path: RoutePaths.paymentScreen,
      pageBuilder: (context, state) => CupertinoPage(
          child: const PaymentScreen(),
          key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.productScreen,
      pageBuilder: (context, state){
        final data = state.extra as Map<String, dynamic>?;
        final product = data?['product'] as Product?;
        if(product != null){
          return CupertinoPage(
              child: ProductScreen(product: product),
              key: state.pageKey
          );
        }
        return CupertinoPage(
          child: const ErrorBuilder(message: 'The product object was not passed while navigating to the product screen',),
          key: state.pageKey
        );
      }
    ),
    GoRoute(
      path: RoutePaths.resetEmailSentScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const ResetEmailSentScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.searchScreen,
      pageBuilder: (context, state){
        return CustomTransitionPage(
          child: const SearchScreen(),
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, _, child){
            return SlideTransition(
              position: animation.drive(CurveTween(curve: Curves.easeIn)).drive(
                Tween<Offset>(
                  begin: Offset(0, 1),
                  end: Offset(0, 0)
                ),
              ),
              child: child,
            );
          }
        );
      }
    ),
    GoRoute(
      path: RoutePaths.setPreferencesScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const SetPreferencesScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.signInScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const SignInScreen(),
        key: state.pageKey
      )
    ),
    GoRoute(
      path: RoutePaths.splashScreen,
      pageBuilder: (context, state) => CupertinoPage(
        child: const SplashScreen(),
        key: state.pageKey,
      ),
    ),
  ]
);

class ErrorBuilder extends StatelessWidget {
  final String? message;
  const ErrorBuilder({
    this.message,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          message ?? 'Navigation error has occurred',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.error
          ),
        ),
      ),
    );
  }
}