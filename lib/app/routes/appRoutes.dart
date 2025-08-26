import 'package:get/get.dart';
import 'package:wallet_module/app/get/bindings/wallet_binding.dart';
import 'package:wallet_module/app/screen/waller_Screen.dart';

class AppRoutes{
  /// Routes names
  static const String initialRoute = '/';

  /// Routes pages
  static final routes = [
    GetPage(name: initialRoute, page: ()=> WallerScreen(), binding: WalletBinding()),
  ];
}