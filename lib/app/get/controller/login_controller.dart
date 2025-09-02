import 'package:get/get.dart';
import '../../data/firebase_services/firebase_auth_service.dart';
import '../../routes/appRoutes.dart';

class LoginController extends GetxController{
  final FirebaseAuthServices _authService = FirebaseAuthServices();
  var isLoading = false.obs;

  /// -- Login method
  Future<void> login({required String email, required String password}) async{
    try {
      isLoading.value = true;
      await _authService.signIn(email: email, password: password); // return credentials.user
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.walletRoute);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Login Error: ", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}