import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../get/controller/wallet_controller.dart';
import '../../utils/device_constants/appColors.dart';
import '../../utils/device_utils/scale_utility.dart';

class WalletFrontEnd extends StatelessWidget {
  const WalletFrontEnd({super.key});

  @override
  Widget build(BuildContext context) {

    /// -- Initialize "ScalingUtility" class in EachScreen.
    final scale = ScalingUtility(context: context);
    scale.setCurrentDeviceSize();

    var walletController = Get.find<WalletController>();

    return Obx(
      (){
        return ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(20),
          child: Container(
            height: scale.getScaledHeight(180),
            width: scale.getScaledWidth(360),
            decoration: BoxDecoration(
              color: AppColors.black,
              border: Border.all(width: 0, color: AppColors.black),
              borderRadius: BorderRadiusGeometry.circular(20),
              image: const DecorationImage(
                  image: AssetImage("assets/image/wallet/noise.png"),
                  fit: BoxFit.fill
              ),
            ),
            child: Stack(
                children:[
                  /// -- Annakosh Wallet Golden Chip
                  Positioned(
                    top: scale.getScaledHeight(30),
                    left: scale.getScaledWidth(20),
                    child: Image.asset(
                      "assets/image/wallet/wallet_golden_chip.png",
                      height: scale.getScaledHeight(30),
                      width: scale.getScaledWidth(42),
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// -- Base layer of Annakosh Wallet
                  Padding(
                    padding: scale.getPadding(top: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// -- User Name and Card Network Logo
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: SizedBox(width: scale.getScaledWidth(10),)),
                            AutoSizeText("Tarun jain", style: TextStyle(fontSize: scale.getScaledFont(16), color: AppColors.white, fontWeight: FontWeight.bold),),
                            SizedBox(width: scale.getScaledWidth(10),),
                            Image.asset("assets/image/wallet/card_network_logo.png", height: scale.getScaledHeight(18), width: scale.getScaledWidth(18), fit: BoxFit.contain,),
                            SizedBox(width: scale.getScaledWidth(20)),
                          ],
                        ),

                        /// -- Current Balance
                        SizedBox(height: scale.getScaledHeight(44)),
                        Padding(
                          padding: scale.getPadding(left: 20),
                          child: AutoSizeText("Current Balance", style: TextStyle(fontSize: scale.getScaledFont(14), color: Colors.grey.shade500, fontWeight: FontWeight.w800),),
                        ),

                        /// -- Annkosh Wallet Amount
                        Padding(
                          padding: scale.getPadding(left: 20),
                          child: AutoSizeText(walletController.getCoins(), style: TextStyle(fontSize: scale.getScaledFont(24), color: AppColors.yellowTextColor, fontWeight: FontWeight.bold),),
                        ),

                        /// -- Divider Lines
                        SizedBox(height: scale.getScaledHeight(18)),
                        Divider(color: AppColors.yellowTextColor, thickness: 2, height: 0,),
                        Divider(color: AppColors.white, thickness: 0.5, height: 6,),

                        /// -- Annakosh Wallet logo and Name
                        SizedBox(height: scale.getScaledHeight(1.5)),
                        Padding(
                          padding: scale.getPadding(left: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset("assets/image/wallet/app_card_logo.png", height: scale.getScaledHeight(20), width: scale.getScaledWidth(28), fit: BoxFit.cover,),
                              AutoSizeText("Annakosh Wallet", style: TextStyle(fontSize: scale.getScaledFont(14), color: AppColors.white, fontWeight: FontWeight.w800),),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  /// -- Annakosh wallet lines logo
                  Image.asset(
                    "assets/image/wallet/line.png",
                    height: scale.getScaledHeight(160),
                    width: scale.getScaledWidth(360),
                    fit: BoxFit.cover,
                  ),

                  /// -- Annakosh Gold Coin Layer
                  Positioned(
                    top: scale.getScaledHeight(36),
                    right: scale.getScaledWidth(-94),
                    child: Image.asset(
                      "assets/image/wallet/gold_coin.png",
                      height: scale.getScaledHeight(240),
                      width: scale.getScaledWidth(240),
                      fit: BoxFit.contain,
                    ),
                  ),
                ]
            ),
          ),
        );
      },
    );
  }
}
