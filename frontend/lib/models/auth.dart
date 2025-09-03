import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:frontend/providers/post_categories.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseReference _dbUserRef = FirebaseDatabase.instance.ref("users");

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        await _checkAndCreateUser(user);
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during Google Sign-in: ${e.code}');
      return null;
    } catch (e) {
      print('An unexpected error occurred during Google Sign-in: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> _checkAndCreateUser(User user) async {
    final userRef = _dbUserRef.child(user.uid);
    final snapshot = await userRef.get();

    if (!snapshot.exists) {
      final Map<String, int> initialCategories = {
        for (var cat in postCategories.keys) cat: 0
      };

      await userRef.set(initialCategories);
    }
  }
}
