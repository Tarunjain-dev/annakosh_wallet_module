import "dart:ui";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:get/get.dart";
import "package:money_formatter/money_formatter.dart";

import "../../data/models/user_model.dart";

class WalletController extends GetxController {

  List<String> servicesImages = [
    "assets/image/comming_soon/electricityBill.png",
    "assets/image/comming_soon/insurance.png",
    "assets/image/comming_soon/restaurant.png",
    "assets/image/comming_soon/shopping.png",
    "assets/image/comming_soon/Fuel.png",
    "assets/image/comming_soon/giftcard.png",
  ];

  List<String> servicesNames = [
    "Property",
    "Jobs",
    "Electricity Repair",
    "Shopping",
    "Petrol & Diesel",
    "E-Gift Cards",
  ];

  List<Color> servicesColors = [
    const Color(0xffFFE6B7),
    const Color(0xffC7EAFF),
    const Color(0xffFFC5D5),
    const Color(0xffB7FFC9),
    const Color(0xffC7EAFF),
    const Color(0xffFFE6B7)
  ];

  var annakoshTotalCoins = 0.obs;
  var userData = Rxn<UserModel>();  // reactive user model
  var directConnections = <UserModel>[].obs;    // list of direct users
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// -- getCoins
  String getCoins({required double coins}) {
    double coin = coins;
    return _formatIndianCurrency(coin);
  }

  /// -- Rupee Formatter
  MoneyFormatter rupeeFormatter(double amount) {
    return MoneyFormatter(
      amount: amount,
      settings: MoneyFormatterSettings(
        symbol: '₹',
        thousandSeparator: ',',
        decimalSeparator: '.',
        fractionDigits: 2,
        compactFormatType: CompactFormatType.short,
      ),
    );
  }

  /// -- Custom Indian Comma Placement
  String _formatIndianCurrency(double amount) {
    String value = amount.toStringAsFixed(0);
    String result = "";
    int counter = 0;

    for (int i = value.length - 1; i >= 0; i--) {
      result = value[i] + result;
      counter++;

      if (i > 0) {
        if (counter == 3) {
          result = "," + result;
        } else if (counter > 3 && (counter - 3) % 2 == 0) {
          result = "," + result;
        }
      }
    }

    return "₹$result";
  }

  /// Realtime User Data Listener
  void listenToUserData() {
    final currentUser = auth.currentUser;
    if (currentUser == null) return;

    firestore.collection("users").doc(currentUser.uid).snapshots().listen((doc) {
      if (doc.exists) {
        userData.value = UserModel.fromJson(doc.data()!);
        fetchDirectConnections(); // also refresh directs
      }
    });
  }

  /// Realtime Direct Connections
  void fetchDirectConnections() async {
    if (userData.value == null) return;

    directConnections.clear();

    try {
      final directUIDs = userData.value!.directs ?? [];

      for (String uid in directUIDs) {
        firestore.collection("users").doc(uid).snapshots().listen((doc) {
          if (doc.exists) {
            final user = UserModel.fromJson(doc.data()!);

            // agar user pehle se list me hai toh update karo, warna add karo
            final index = directConnections.indexWhere((u) => u.currentUserUid == user.currentUserUid);
            if (index >= 0) {
              directConnections[index] = user;
            } else {
              directConnections.add(user);
            }
          }
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch directs: $e");
    }
  }


  @override
  void onInit() {
    super.onInit();
    listenToUserData(); // realtime listen
  }
}
