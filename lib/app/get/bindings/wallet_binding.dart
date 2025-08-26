import 'package:get/get.dart';
import '../controller/wallet_controller.dart';

class WalletBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<WalletController>(() => WalletController());
  }
}