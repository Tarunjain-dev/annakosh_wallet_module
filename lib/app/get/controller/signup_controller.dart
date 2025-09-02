import 'dart:math';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/firebase_services/firebase_auth_service.dart';
import '../../data/firebase_services/firebase_firestore_service.dart';
import '../../data/models/user_model.dart';
import '../../routes/appRoutes.dart';

class SignupController extends GetxController {
  final FirebaseAuthServices _authService = FirebaseAuthServices();
  final FirbaseFirestoreService _firestoreService = FirbaseFirestoreService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;

  /// --- SignUp Method
  Future<void> signUp({
    required String userName,
    required String email,
    required String password,
    String? referralCode, // optional
  }) async {
    try {
      isLoading.value = true;

      final userCred = await _authService.signUp(email: email, password: password);
      if (userCred == null || userCred.user == null) {
        throw Exception("Signup failed: No user credentials.");
      }

      final currentUid = userCred.user!.uid;

      // Generate unique referral code for this user
      final myReferralCode = await createAndStoreReferralCode(currentUid);

      // Create user entry
      final user = UserModel(
        userName: userName,
        email: email,
        password: password,
        currentUserUid: currentUid,
        currentUserReferralCode: myReferralCode,
        parentUserUid: null,
        numberOfDirectReferrals: 0,
        directs: [],
        totalAnnakoshCoins: 0,
        bonusPoints: 0, // <-- new field
      );

      // Save user initially
      await _firestoreService.saveUser(user);

      if (referralCode != null && referralCode.trim().isNotEmpty) {
        /// If referral code entered → handle referral logic
        final parentUserId = await handleReferral(referralCode.trim(), currentUid);

        /// --- Trigger bonus distribution from parent upwards
        if (parentUserId != null) {
          // Todo: This is causing the error solve this first.
          await distributeBonus(newUserId: currentUid, baseAmount: 100); // Base price = ₹100
        }
      } else {
        /// If no referral code → directly give 250 coins to the new user
        await firestore.collection("users").doc(currentUid).update({
          "totalAnnakoshCoins": FieldValue.increment(250),
        });
      }

      isLoading.value = false;
      Get.offAllNamed(AppRoutes.loginRoute);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Signup Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// --- Generate 6-digit unique referral code
  String generateReferralCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    String code = List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
    return code;
  }

  /// --- Create unique referral code and store
  Future<String> createAndStoreReferralCode(String userId) async {
    String code;
    bool exists = true;

    do {
      code = generateReferralCode();
      exists = await _firestoreService.isReferralCodeExists(code: code);
    } while (exists);

    await _firestoreService.saveReferralCode(userId: userId, code: code);
    return code;
  }

  /// --- Handle Referral Logic
  Future<String?> handleReferral(String referralCode, String newUserUid) async {
    try {
      final snapshot = await firestore
          .collection("referral_codes")
          .where("code", isEqualTo: referralCode)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null; // invalid referral code

      final parentUserId = snapshot.docs.first["userId"];

      // Add child to parent user's directs & increment direct referrals
      await firestore.collection("users").doc(parentUserId).update({
        "directs": FieldValue.arrayUnion([newUserUid]),
        "numberOfDirectReferrals": FieldValue.increment(1),
        "totalAnnakoshCoins": FieldValue.increment(250),
      });

      // Add parentUserUid to child user
      await firestore.collection("users").doc(newUserUid).update({
        "parentUserUid": parentUserId,
        "totalAnnakoshCoins": FieldValue.increment(250),
      });

      return parentUserId;
    } catch (e) {
      print("Referral handling error: $e");
      return null;
    }
  }

  /// --- Bonus Distribution (Algorithm)
  /// Bonus Points Distribution Algorithm
  Future<void> distributeBonus({
    required String newUserId,
    double baseAmount = 100.0, // as per your rule
  }) async {
    try {
      final users = FirebaseFirestore.instance.collection('users');

      // 1) New (current) user
      final newUserSnap = await users.doc(newUserId).get();
      if (!newUserSnap.exists) return;

      // Direct referrer = parentUserUid of current user
      final String? directReferrerId = (newUserSnap.data()?['parentUserUid'] as String?);
      if (directReferrerId == null || directReferrerId.isEmpty) {
        // koi referrer nahi => koi bonus nahi
        return;
      }

      // 2) Start from: direct referrer ka parent (skip direct referrer)
      final directRefSnap = await users.doc(directReferrerId).get();
      if (!directRefSnap.exists) return;

      String? ancestorId = (directRefSnap.data()?['parentUserUid'] as String?);

      // 3) Percentages for 10 levels
      final List<int> percentages = [10,9,8,7,6,5,4,3,2,1];

      // 4) Ancestors collect karo (max 10)
      final List<String> ancestorIds = [];
      for (int i = 0; i < percentages.length; i++) {
        if (ancestorId == null || ancestorId.isEmpty) break;

        final ancSnap = await users.doc(ancestorId).get();
        if (!ancSnap.exists) break;

        ancestorIds.add(ancestorId);

        // next ancestor (move up the tree)
        ancestorId = (ancSnap.data()?['parentUserUid'] as String?);
      }

      if (ancestorIds.isEmpty) return;

      // 5) Batch update with FieldValue.increment (ADD, not overwrite)
      final batch = FirebaseFirestore.instance.batch();
      for (int i = 0; i < ancestorIds.length; i++) {
        final addPoints = ((baseAmount * percentages[i]) / 100).round(); // int
        final ancRef = users.doc(ancestorIds[i]);
        batch.update(ancRef, {
          'bonusPoints': FieldValue.increment(addPoints),
        });
      }
      await batch.commit();

      // (optional) debug
      // print('Bonus distributed to ${ancestorIds.length} ancestors for $newUserId');
    } catch (e) {
      Get.snackbar('Bonus Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}

