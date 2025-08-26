import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet_module/app/get/controller/wallet_controller.dart';
import 'package:wallet_module/app/screen/widgets/wallet_backend.dart';
import 'package:wallet_module/app/screen/widgets/wallet_frontend.dart';
import 'package:wallet_module/app/utils/device_constants/appColors.dart';
import 'package:wallet_module/app/utils/device_utils/scale_utility.dart';

class WallerScreen extends StatelessWidget {
  const WallerScreen({super.key});

  @override
  Widget build(BuildContext context) {

    /// --  Initialize Scaling Utility class in every screen
    final scale = ScalingUtility(context: context);
    scale.setCurrentDeviceSize();

    WalletController walletController = Get.find<WalletController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: AutoSizeText("Annakosh Wallet", style: TextStyle(fontSize: scale.getScaledFont(18), color: AppColors.white, fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: scale.getPadding(all: 10),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              /// -- Annakosh Wallet Flip Card
              FlipCard(
                fill: Fill.fillBack,
                direction: FlipDirection.HORIZONTAL,
                speed: 20000,
                side: CardSide.FRONT,
                front: WalletFrontEnd(),
                back: WalletBackend(),
              ),

              /// -- CTA Buttons
              SizedBox(height: scale.getScaledHeight(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: ()=> walletController.plus250(),
                      style: ButtonStyle(
                        side: WidgetStatePropertyAll(BorderSide(width: 2, color: AppColors.primaryColor)),
                      ),
                      child: Text("Plus 250", style: TextStyle(color: AppColors.black, fontSize: scale.getScaledFont(18)),),
                  ),

                  TextButton(
                    onPressed: ()=> walletController.minus250(),
                    style: ButtonStyle(
                      side: WidgetStatePropertyAll(BorderSide(width: 2, color: AppColors.primaryColor)),
                    ),
                    child: Text("Minus 250", style: TextStyle(color: AppColors.black, fontSize: scale.getScaledFont(18)),),
                  ),

                  TextButton(
                    onPressed: ()=> walletController.twoX(),
                    style: ButtonStyle(
                      side: WidgetStatePropertyAll(BorderSide(width: 2, color: AppColors.primaryColor)),
                    ),
                    child: Text("Get Double", style: TextStyle(color: AppColors.black, fontSize: scale.getScaledFont(18)),),
                  ),
                ],
              ),

              SizedBox(height: scale.getScaledHeight(8)),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: ()=> walletController.reset(),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
                    side: WidgetStatePropertyAll(BorderSide(width: 2, color: AppColors.primaryColor)),
                  ),
                  child: Text("Reset Coins", style: TextStyle(color: AppColors.white, fontSize: scale.getScaledFont(18)),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
