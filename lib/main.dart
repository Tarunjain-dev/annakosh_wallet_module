import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wallet_module/app/localization/languages.dart';
import 'package:wallet_module/app/routes/appRoutes.dart';
import 'package:wallet_module/app/utils/device_utils/size_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/get/controller/language_Controller.dart';
import 'firebase_options.dart';

void main() async{
  /// -- Initialize Firebase.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  /// -- Initialize Local GetStorage.
  await GetStorage.init();
  final storage = GetStorage();
  String savedLang = storage.read("selectedLanguage") ?? "en";
  Locale initialLocale;
  if (savedLang == "hi") {
    initialLocale = const Locale("hi", "IN");
  } else {
    initialLocale = const Locale("en", "US");
  }

  /// -- Initialize LanguageController : make it available everywhere
  Get.put(LanguageController());

  /// -- Run App
  runApp(MyApp(initialLocale: initialLocale));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  const MyApp({super.key, this.initialLocale =  const Locale("en", "US")});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'Annakosh Wallet Module',
          locale: initialLocale,
          translations: AppLanguages(),
          fallbackLocale: Locale("en", "US"),
          initialRoute: AppRoutes.initialRoute,
          getPages: AppRoutes.routes,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

