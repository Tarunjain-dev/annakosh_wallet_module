import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../get/controller/signup_controller.dart';
import '../utils/device_constants/appColors.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  /// -- Form Key
  final formKey = GlobalKey<FormState>();

  /// -- TextField Controllers
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final referralCodeController = TextEditingController();

  /// -- FocusNodes
  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode referralCodeFocusNode = FocusNode();

  /// -- Signup Controller Instance
  final SignupController signupController = Get.find<SignupController>();
  // Make sure SignupController is registered in your binding.

  Future<void> signUpUser() async {
    if (formKey.currentState!.validate()) {
      String name = userNameController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String confirmPassword = confirmPasswordController.text.trim();
      String? referralCode = referralCodeController.text.trim().isEmpty ? null : referralCodeController.text.trim();

      if (password != confirmPassword) {
        Get.snackbar("Error", "Passwords do not match",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      await signupController.signUp(
        userName: name,
        email: email,
        password: password,
        referralCode: referralCode,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Signup Screen",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),

                /// -- User Name TextField
                TextFormField(
                  controller: userNameController,
                  focusNode: userNameFocusNode,
                  cursorColor: AppColors.primaryColor,
                  style: TextStyle(color: AppColors.grey),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter user name";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(emailFocusNode),
                  decoration: _inputDecoration("User Name", Icons.person),
                ),
                SizedBox(height: 10),

                /// -- Email TextField
                TextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: AppColors.primaryColor,
                  style: TextStyle(color: AppColors.grey),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter email";
                    }
                    if (!RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$")
                        .hasMatch(value)) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(passwordFocusNode),
                  decoration: _inputDecoration("Email", Icons.email),
                ),
                SizedBox(height: 10),

                /// -- Password TextField
                TextFormField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  obscureText: false,
                  cursorColor: AppColors.primaryColor,
                  style: TextStyle(color: AppColors.grey),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter password";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(confirmPasswordFocusNode),
                  decoration: _inputDecoration("Password", Icons.lock),
                ),
                SizedBox(height: 10),

                /// -- Confirm Password TextField
                TextFormField(
                  controller: confirmPasswordController,
                  focusNode: confirmPasswordFocusNode,
                  obscureText: false,
                  cursorColor: AppColors.primaryColor,
                  style: TextStyle(color: AppColors.grey),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Confirm your password";
                    }
                    if (value != passwordController.text.trim()) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(referralCodeFocusNode),
                  decoration: _inputDecoration("Confirm Password", Icons.lock),
                ),
                SizedBox(height: 10),

                /// -- Referral Code (optional)
                TextFormField(
                  controller: referralCodeController,
                  focusNode: referralCodeFocusNode,
                  cursorColor: AppColors.primaryColor,
                  style: TextStyle(color: AppColors.grey),
                  decoration: _inputDecoration(
                      "Referral Code (optional)", Icons.add_link_rounded),
                ),

                SizedBox(height: 30),

                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: signupController.isLoading.value ? null : signUpUser,
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                        ),
                        child: signupController.isLoading.value
                            ? CircularProgressIndicator(color: AppColors.white, strokeWidth: 2)
                            : Text("Sign Up", style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 18,),
                        ),
                      ),
                    ),
                  );
                }),

                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                        style: TextStyle(color: AppColors.grey)),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Get.offNamed('/login'),
                      child: Text("Login",
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable Input Decoration
  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.grey),
      prefixIcon: Icon(icon, color: AppColors.grey),
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
    );
  }
}
