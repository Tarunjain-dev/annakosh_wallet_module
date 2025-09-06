import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../get/controller/login_controller.dart';
import '../routes/appRoutes.dart';
import '../utils/device_constants/appColors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static final formKey = GlobalKey<FormState>();
  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();
  static final FocusNode emailFocusNode = FocusNode();
  static final FocusNode passwordFocusNode = FocusNode();

  /// -- Login Controller Instance
  static final LoginController loginController = Get.find<LoginController>();

  void login(){
    if(formKey.currentState!.validate()){
      // Login logic here...
      var email = emailController.text.toString();
      var password = passwordController.text.toString();
      loginController.login(email: email, password: password);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackgroundColor,
      appBar: AppBar(title: Text("login_screen".tr, style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),), backgroundColor: AppColors.primaryColor,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              /// -- Email TextField
              TextFormField(
                controller: emailController,
                focusNode: emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                cursorColor: AppColors.primaryColor,
                maxLines: 1,
                style: TextStyle(color: AppColors.grey),
                validator: (value) {
                  if(value!.isEmpty){
                    return "enter_email".tr;
                  }
                  return null;
                },
                onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(passwordFocusNode),
                decoration: InputDecoration(
                  hintText: "email".tr,
                  hintStyle: TextStyle(color: AppColors.grey),
                  prefixIcon: Icon(Icons.email, color: AppColors.grey,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.grey, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                ),
              ),
              SizedBox(height: 10),

              /// -- Password TextField
              TextFormField(
                controller: passwordController,
                focusNode: passwordFocusNode,
                keyboardType: TextInputType.emailAddress,
                cursorColor: AppColors.primaryColor,
                maxLines: 1,
                style: TextStyle(color: AppColors.grey),
                validator: (value) {
                  if(value!.isEmpty){
                    return "enter_password".tr;
                  }
                  return null;
                },
                onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: "password".tr,
                  hintStyle: TextStyle(color: AppColors.grey),
                  prefixIcon: Icon(Icons.lock, color: Colors.grey,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.grey, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                ),
              ),

              SizedBox(height: 30),
              Obx(
                  ()=> Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10))
                      ),
                      child: loginController.isLoading.value ?
                              CircularProgressIndicator(strokeWidth: 2, color: AppColors.white,) :
                              Text("login_button".tr, style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("dont_have_an_account?".tr, style: TextStyle(color: AppColors.grey)),
                  SizedBox(width: 8),
                  GestureDetector(
                      onTap: (){
                        Get.offNamed(AppRoutes.signupRoute);
                      },
                      child: Text("signup_button".tr, style: TextStyle(color: Colors.blue),),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
