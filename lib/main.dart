import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet_module/app/routes/appRoutes.dart';
import 'package:wallet_module/app/utils/device_utils/size_utils.dart';

void main() {
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

