import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet_module/app/routes/appRoutes.dart';
import 'package:wallet_module/app/utils/device_utils/size_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'Annakosh Wallet Module',
          initialRoute: AppRoutes.initialRoute,
          getPages: AppRoutes.routes,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

