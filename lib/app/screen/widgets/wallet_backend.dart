import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet_module/app/utils/device_constants/appStrings.dart';
import '../../get/controller/language_Controller.dart';
import '../../utils/device_constants/appColors.dart';
import '../../utils/device_utils/scale_utility.dart';

class WalletBackend extends StatelessWidget {
  const WalletBackend({super.key});

  @override
  Widget build(BuildContext context) {

    /// -- Initialize "ScalingUtility" class in EachScreen.
    final scale = ScalingUtility(context: context);
    scale.setCurrentDeviceSize();
    final LanguageController langCtrl = Get.find();

    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(20),
      child: Container(
        height: scale.getScaledHeight(184),
        width: scale.getScaledWidth(360),
        decoration: BoxDecoration(
          color: AppColors.black,
          border: Border.all(width: 0, color: AppColors.black),
          borderRadius: BorderRadiusGeometry.circular(20),
          /// -- Noise Layer
          image: const DecorationImage(
              image: AssetImage("assets/image/wallet/noise.png"),
              fit: BoxFit.fill
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// -- Annakosh Wallet logo and Name
            Padding(
              padding: scale.getPadding(right: 14, top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("app_title".tr, style: TextStyle(fontSize: scale.getScaledFont(14), fontWeight: FontWeight.w800, color: AppColors.white),),
                  Image.asset("assets/image/wallet/app_card_logo.png", height: scale.getScaledHeight(20), width: scale.getScaledWidth(28), fit: BoxFit.cover,),
                ],
              ),
            ),

            /// -- Black Magnetic rectangle
            SizedBox(height: scale.getScaledHeight(2)),
            Container(
              height: scale.getScaledHeight(40),
              width: double.infinity,
              color: Colors.black,
            ),
            SizedBox(height: scale.getScaledHeight(4)),

            /// -- About Annakosh Wallet
            Padding(
              padding: scale.getPadding(left: 20, right: 10, bottom: 6, top: 0),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 20, color: Colors.grey.shade600,),
                  SizedBox(width: scale.getScaledWidth(8)),
                  Text("about_tokrigo_wallet".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: scale.getScaledFont(14), color: Colors.grey.shade600),)
                ],
              ),
            ),

            /// -- Annakosh wallet Description
            Padding(
              padding: scale.getPadding(right: 10, left: 10, bottom: 4),
              child: Container(
                width: double.infinity,
                height: scale.getScaledHeight(78),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(width: 1.5, color: Colors.grey.shade600),
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
                child: Padding(
                  padding: scale.getPadding(all: 4),
                  child: Text("tokrigo_wallet_description".tr, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.normal, fontSize:  scale.getScaledFont(11)),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
