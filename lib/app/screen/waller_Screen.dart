import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet_module/app/screen/widgets/wallet_backend.dart';
import 'package:wallet_module/app/screen/widgets/wallet_frontend.dart';
import '../data/firebase_services/firebase_auth_service.dart';
import '../get/controller/language_Controller.dart';
import '../get/controller/wallet_controller.dart';
import '../routes/appRoutes.dart';
import '../utils/device_constants/appColors.dart';
import '../utils/device_constants/appImages.dart';
import '../utils/device_utils/scale_utility.dart';

class WallerScreen extends StatelessWidget {
  const WallerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = ScalingUtility(context: context);
    scale.setCurrentDeviceSize();

    final authService = FirebaseAuthServices();
    var walletController = Get.find<WalletController>();
    final LanguageController langCtrl = Get.find();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: AutoSizeText(
          "app_title".tr,
          style: TextStyle(
            fontSize: scale.getScaledFont(18),
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          /// -- Language Toggle Button
          Obx(() {
                  return CupertinoSegmentedControl<String>(
              padding: const EdgeInsets.all(6),
              groupValue: langCtrl.selectedLang.value,
              borderColor: Colors.black,
              selectedColor: AppColors.primaryColor,
              children:  {
                "en": Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text("EN", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,),),
                ),
                "hi": Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text("हिं", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,),),
                ),
              },
              onValueChanged: (value) => langCtrl.changeLanguage(value),
            );
                },
          ),

          /// -- My Referral Button
          Padding(
            padding: const EdgeInsets.only(right: 4, left: 4),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                onPressed: () {
                  final user = walletController.userData.value!;
                  Get.defaultDialog(
                    title: user.currentUserReferralCode,
                    titleStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    middleText:"share_referral".tr,
                    middleTextStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    confirm: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "ok".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.question_mark_rounded,
                    color: AppColors.primaryColor, size: 20),
              ),
            ),
          ),

          /// -- Logout Button
          Padding(
            padding: const EdgeInsets.only(right: 4, left: 4),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                onPressed: () {
                  authService.signOut();
                  Get.offAllNamed(AppRoutes.loginRoute);
                },
                icon: Icon(Icons.logout,
                    color: AppColors.primaryColor, size: 20),
              ),
            ),
          ),
        ],
      ),

      body: Obx(() {
        final user = walletController.userData.value;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        var directCount = walletController.directConnections.length; // length of direct connected users.
        var bonusPoints = user.bonusPoints ?? 0;

        return SingleChildScrollView(
          padding: scale.getPadding(all: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Wallet card
              FlipCard(
                fill: Fill.fillBack,
                direction: FlipDirection.HORIZONTAL,
                speed: 10000, // 20,000
                side: CardSide.FRONT,
                front: WalletFrontEnd(),
                back: WalletBackend(),
              ),

              /// -- Bonus points and Direct referral section
              SizedBox(height: scale.getScaledHeight(10),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// -- Bonus points section
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(10),
                    child: Container(
                      width: scale.getScaledWidth(164),
                      height: scale.getScaledHeight(100),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1D0D26), // 0%
                            Color(0xFF251322), // 48%
                            Color(0xFF4A2F12), // 58%
                            Color(0xFFFF961C), // 100%
                          ],
                          stops: [0.00, 0.48, 0.58, 1.00],

                        ),
                      ),
                      child: Stack(
                        children: [
                          /// -- Text Layer
                          Padding(
                            padding: scale.getPadding(top: 16, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// -- Bonus points numbers
                                Text(bonusPoints.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: scale.getScaledFont(20), color: AppColors.yellowTextColor),),

                                /// -- Bonus points text
                                Text("bonus_points".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: scale.getScaledFont(12), color: Colors.white),),
                              ],
                            ),
                          ),

                          /// -- yellow Diamond layer
                          Positioned(
                            top: scale.getScaledHeight(43),
                            left: scale.getScaledWidth(104),
                            child: Image.asset(AppImages.yellowDiamondImage, height: scale.getScaledHeight(80), width: scale.getScaledWidth(80), fit: BoxFit.fill,),
                          ),

                          /// -- dots_layer_3
                          Positioned(
                            left: scale.getScaledWidth(110),
                            child: Image.asset(AppImages.dotImage, height: scale.getScaledHeight(50), width: scale.getScaledWidth(50), fit: BoxFit.fill,),
                          ),

                          /// -- dots_layer2
                          Positioned(
                            top: scale.getScaledHeight(20),
                            left: scale.getScaledWidth(80),
                            child: Image.asset(AppImages.dotImage, height: scale.getScaledHeight(50), width: scale.getScaledWidth(50), fit: BoxFit.fill,),
                          ),

                          /// -- dots_layer1
                          Positioned(
                            top: scale.getScaledHeight(46),
                            left: scale.getScaledWidth(90),
                            child: Image.asset(AppImages.dotImage, height: scale.getScaledHeight(50), width: scale.getScaledWidth(50), fit: BoxFit.fill,),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// -- Direct Referrals section
                  SizedBox(width: scale.getScaledWidth(6),),
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(10),
                    child: Container(
                      width: scale.getScaledWidth(164),
                      height: scale.getScaledHeight(100),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1A0C0C), // 0%
                            Color(0xFF803A3A), // 80%
                            Color(0xFF9F2A2A), // 96%
                          ],
                          stops: [0.00, 0.80, 0.96],
                        ),
                      ),
                      child: Stack(
                        children: [
                          /// -- Direct Referral Numbers and other texts
                          Padding(
                            padding: scale.getPadding(top: 16, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// -- Direct Connection Referral numbers
                                Text(directCount.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: scale.getScaledFont(20), color: Colors.red),),

                                /// -- Direct Referral text
                                Text("direct_referrals".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: scale.getScaledFont(12), color: Colors.white),),

                                /// -- Your network is growing!
                                Text("network_growing".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: scale.getScaledFont(9), color: Colors.white),),

                                /// -- Circular circular avtar overlay layer
                                SizedBox(height: scale.getScaledHeight(6)),
                                Image.asset(AppImages.circleAvtarRowImage, height: scale.getScaledHeight(14), width: scale.getScaledWidth(52), fit: BoxFit.fill,),

                              ],
                            ),
                          ),

                          /// -- Three person connected Image
                          Positioned(
                            top: scale.getScaledHeight(26),
                            left: scale.getScaledWidth(118),
                            child: Image.asset(AppImages.threePeoplesConnectionImage, height: scale.getScaledHeight(30), width: scale.getScaledWidth(31), fit: BoxFit.fill,),
                          ),

                          /// -- Direct Connection Image
                          Positioned(
                            left: scale.getScaledWidth(80),
                            top: scale.getScaledHeight(2),
                            child: Image.asset(AppImages.directConnectionImage, height: scale.getScaledHeight(100), width: scale.getScaledWidth(100), fit: BoxFit.fill,),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),

              /// -- CTA Buttons
              SizedBox(height: scale.getScaledHeight(20)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  // TODO: Start from here...
                  "manage_bills".tr,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),

              /// -- Services List Horizontal
              SizedBox(height: scale.getScaledHeight(4),),
              SizedBox(
                height: scale.getScaledHeight(95),
                child: ListView.builder(
                  itemCount: 6,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => buildComingSoonCard(
                      title: walletController.servicesNames[index],
                      asset: walletController.servicesImages[index],
                      bgColor: walletController.servicesColors[index],
                  ),
                ),
              ),

            // SizedBox(
            //   height: scale.getScaledHeight(95),
            //   child: Obx(() => ListView.builder(
            //     itemCount: walletController.servicesNames.length,
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) => buildComingSoonCard(
            //       title: walletController.servicesNames[index],
            //       asset: walletController.servicesImages[index],
            //       bgColor: walletController.servicesColors[index],
            //     ),
            //   )),
            // ),

              /// -- Direct Connection List Row Divider
              Row(
                children: [
                  Expanded(child: Divider(indent: 4, endIndent: 4)),
                  Text("direct_connection_list".tr,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Expanded(child: Divider(indent: 4, endIndent: 4)),
                ],
              ),

              /// -- Direct Connection List
              Obx(() {
                if (walletController.directConnections.isEmpty) {
                  return Center(child: Text("no_direct_connections".tr));
                }
                return ListView.builder(
                  shrinkWrap: true, // Important for scroll inside SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: walletController.directConnections.length,
                  itemBuilder: (context, index) {
                    final directUser =
                    walletController.directConnections[index];
                    return ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffDAFF9F),
                          image: DecorationImage(image: AssetImage("assets/image/avtar/avtar1.png"), fit: BoxFit.contain)
                        ),
                      ),
                      title: Text(directUser.userName),
                      subtitle: Text(directUser.email),
                    );
                  },
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  /// -- Small reusable widget for Coming soon cards
  Widget buildComingSoonCard({required String asset, required String title, required Color bgColor}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Container(
            height: 66,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: bgColor,
            ),
            child: Image.asset(asset),
          ),
          const SizedBox(height: 4),
          Text(
            title.tr,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
        ],
      ),
    );
  }
}
