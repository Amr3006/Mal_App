import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mal_app/Data/Models/User%20Model.dart';
import 'package:mal_app/Data/Shared%20Preferences/Shared%20Preferences.dart';
import 'package:mal_app/Shared/Constants/Data.dart';

class Authentication {
  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;

  Authentication() {
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
  }

  // login With email
  Future<void> loginWithEmail(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      bool saved = await saveuId(userCredential.user!);
      if (!saved) {
        throw "uId not saved";
      }
  }

  Future<User?> loginWithFacebook() async {
    // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

  // Once signed in, return the UserCredential
  final credential = await _auth.signInWithCredential(facebookAuthCredential);

  return credential.user;
  }

  // Sign in with Google
  Future<User?> loginWithGoogle() async {
    final gUser = await GoogleSignIn().signIn();

    final gAuth = await gUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth?.accessToken,
      idToken: gAuth?.idToken
    );
    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  } 

  // Create User in Firestore
  Future<void> createUser(User user, UserModel model) async {
    await _firestore
      .collection("Users")
      .doc(user.uid)
      .set(model.toJson());
      bool saved = await saveuId(user);
      if (!saved) {
        throw "uId not Saved" ;
      }
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    final credential =  await _auth.createUserWithEmailAndPassword(email: email, password:password);
    return credential.user;
  }
  
  // Save uId
  Future<bool> saveuId(User user) async {
    uId = user.uid;
    return await CacheHelper.saveData("uId", user.uid);
  } 
}