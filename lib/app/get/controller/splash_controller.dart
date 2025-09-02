import 'dart:async';
import 'package:get/get.dart';
import '../../data/firebase_services/firebase_auth_service.dart';
import '../../routes/appRoutes.dart';

class SplashController extends GetxController {

  final FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();

  void isLogin(){
    final user = firebaseAuthServices.auth.currentUser;

    Timer(Duration(seconds: 3), (){
      if(user != null){
        /// -- user is already logged in
        Get.offNamed(AppRoutes.walletRoute);
      }else{
        /// -- user is not logged in
        Get.offNamed(AppRoutes.loginRoute);
      }
    });
  }
}