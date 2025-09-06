import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  var selectedLang = "en".obs;

  final storage = GetStorage();
  final storageKey = "selectedLanguage";

  @override
  void onInit() {
    super.onInit();
    // Load saved language from local storage, default to "en"
    String savedLang = storage.read(storageKey) ?? "en";
    selectedLang.value = savedLang;
    updateLocale(savedLang);
  }

  /// -- Change Language Method
  void changeLanguage(String langCode) {
    selectedLang.value = langCode;
    updateLocale(langCode);
    // Store user preference locally
    storage.write(storageKey, langCode);
  }

  /// -- Store User language preference in GetX local storage.
  void updateLocale(String langCode) {
    if (langCode == "en") {
      Get.updateLocale(const Locale("en", "US"));
    } else if (langCode == "hi") {
      Get.updateLocale(const Locale("hi", "IN"));
    }
  }
}