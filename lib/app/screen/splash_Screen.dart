import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../get/controller/splash_controller.dart';
import '../utils/device_constants/appColors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    /// -- After 3 seconds navigate to login screen
    var splashController = Get.find<SplashController>();
    splashController.isLogin();

    return Scaffold(
      backgroundColor: AppColors.splashBackgroundColor,
      body: Center(child: Text("Tokrigo Wallet Module", style: TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.bold))),
    );
  }
}
