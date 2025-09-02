import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices{
  /// -- Instance of firebase authentication
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// -- SignUp method
  Future<UserCredential> signUp({required String email, required String password}) async{
    final userCredentials = await auth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredentials;
  }

  /// -- SignIn method
  Future<UserCredential?> signIn({required String email, required String password}) async {
    final credentials = await auth.signInWithEmailAndPassword(email: email, password: password);
    return credentials;
  }

  /// -- SignOut Method
  Future<void> signOut() async{
    await auth.signOut();
  }

  // /// Get current user UID
  // Future<String> getCurrentUserId() async{
  //   final user = auth.currentUser;
  //   return user!.uid; // Returns null if no user is signed in
  // }

  /// Current User UID
  String? getCurrentUserUid() {
    return auth.currentUser?.uid;
  }


  /// Check if user is signed in
  bool isUserLoggedIn() {
    return auth.currentUser != null;
  }
}