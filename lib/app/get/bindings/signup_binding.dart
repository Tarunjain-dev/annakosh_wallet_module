import 'package:get/get.dart';

import '../controller/signup_controller.dart';

class SignupBinding implements Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<SignupController>(() => SignupController());
  }
}