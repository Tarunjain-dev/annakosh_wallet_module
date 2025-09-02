import 'package:get/get.dart';
import 'package:wallet_module/app/get/bindings/signup_binding.dart';
import 'package:wallet_module/app/get/bindings/splash_binding.dart';
import 'package:wallet_module/app/get/bindings/wallet_binding.dart';
import 'package:wallet_module/app/screen/login_Screen.dart';
import 'package:wallet_module/app/screen/signup_Screen.dart';
import 'package:wallet_module/app/screen/splash_Screen.dart';
import 'package:wallet_module/app/screen/waller_Screen.dart';
import '../get/bindings/login_binding.dart';

class AppRoutes{
  /// Routes names
  static const String initialRoute = '/';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String walletRoute = '/wallet';

  /// Routes pages
  static final routes = [
    GetPage(name: initialRoute, page: ()=> SplashScreen(), binding: SplashBinding()),
    GetPage(name: loginRoute, page: ()=> LoginScreen(), binding: LoginBinding()),
    GetPage(name: signupRoute, page: ()=> SignupScreen(), binding: SignupBinding()),
    GetPage(name: walletRoute, page: ()=> WallerScreen(), binding: WalletBinding()), // Home screen
  ];
}