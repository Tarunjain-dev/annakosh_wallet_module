import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirbaseFirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Check if referral code exists
  Future<bool> isReferralCodeExists({required String code}) async {
    final snapshot = await firestore.collection("referral_codes")
        .where("code", isEqualTo: code)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  /// Save referral code
  Future<void> saveReferralCode({required String userId, required String code}) async {
    await firestore.collection("referral_codes").doc(userId).set({
      "userId": userId,
      "code": code,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// Save user
  Future<void> saveUser(UserModel user) async {
    await firestore.collection("users").doc(user.currentUserUid).set(user.toJSON());
  }
}
