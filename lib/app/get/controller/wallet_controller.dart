import "dart:ui";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";


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

  List<String> get servicesNames =>  [
    "property",
    "jobs",
    "electricity_repair",
    "insurance",
    "finance_services",
    "legal_services",
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

  String _formatIndianCurrency(double amount) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    print("Formatted Currency: ${currencyFormatter.format(123456.78)}"); // ₹1,23,456.78
    return currencyFormatter.format(amount).toString();
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
