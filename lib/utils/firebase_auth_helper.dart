import 'package:chat_flutter_app/utils/firebasestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class FirebaseAuthHelper {
  FirebaseAuthHelper._();

  static final FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper._();
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  String? email;
  String? password;

  Future<Map<String, dynamic>> signInAnonymosly() async {
    Map<String, dynamic> data = {};

    try {
      UserCredential userCredential = await firebaseAuth.signInAnonymously();

      User? user = userCredential.user;

      data['user'] = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          data['msg'] = "This service temporarily not available..";
          break;

        case "network-request-failed":
          data['msg'] = "Internet connecion not available..";
          break;

        default:
          data['msg'] = e.code;
          break;
      }
    }

    return data;
  }

// todo: signUpWithEmailandpassword

  Future<Map<String, dynamic>> signupWithEmailPassword(
      {required String email, required String password}) async {
    Map<String, dynamic> data = {};

    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      data['user'] = user;

      Map<String, dynamic> userData = {
        "email": user!.email,
        "uid": user.uid,
      };

      await FireStoreHelper.fireStoreHelper
          .insertUserWhileSignIn(data: userData);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          data["msg"] = "This service temporary down";
          break;
        case "weak-password":
          data["msg"] = "Password must be grater than 6 char.";
          break;
        case "email-already-in-use":
          data["msg"] = "User with this email id is already exists";
          break;
        default:
          data['msg'] = e.code;
      }
    }
    return data;
  }

//todo: signinwithEmailandPassword
  Future<Map<String, dynamic>> signinWithEmailPassword(
      {required String email, required String password}) async {
    Map<String, dynamic> data = {};

    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      data['user'] = user;

      Map<String, dynamic> userData = {
        "email": user!.email,
        "uid": user.uid,
      };
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          data["msg"] = "This service temporary down";
          break;
        case "wrong-password":
          data["msg"] = "Password is wrong";
          break;
        case "user-not-found":
          data["msg"] = "User does not exists with this email id";
          break;
        case "user-disabled":
          data["msg"] = "User is disabled ,contact admin";
          break;
        default:
          data['msg'] = e.code;
      }
    }
    return data;
  }

//todo: signInWithGoogle

  Future<Map<String, dynamic>> signInWithGoogle() async {
    Map<String, dynamic> data = {};

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = userCredential.user;
      data['user'] = user;

      Map<String, dynamic> userData = {
        "email": user!.email,
        "uid": user.uid,
      };

      await FireStoreHelper.fireStoreHelper
          .insertUserWhileSignIn(data: userData);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          data["msg"] = "This service temporary down";
          break;
        default:
          data['msg'] = e.code;
      }
    }
    return data;
  }

//todo: signout

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}

// class FacebookLoginHelper {
//   static final facebookAuth = FirebaseAuth.instance;
//
//   static Future<UserCredential?> signInWithFacebook() async {
//
//     final LoginResult result = await FacebookAuth.instance.login();
//
//     print("=========================================");
//     print(result);
//     print("=========================================");
//
//     if (result.status == LoginStatus.success) {
//       final accessToken = result.accessToken;
//
//       print("=========================================");
//       print(accessToken);
//       print("=========================================");
//
//       final AuthCredential credential = FacebookAuthProvider.credential(accessToken!.token);
//
//       print("=========================================");
//       print(credential);
//       print("=========================================");
//
//       final UserCredential userCredential = await facebookAuth.signInWithCredential(credential);
//
//       print("=========================================");
//       print(userCredential);
//       print("=========================================");
//
//       return userCredential;
//
//
//     } else if (result.status == LoginStatus.cancelled) {
//       print("=======================================");
//       print("Facebook login cancelled by user");
//       print("=======================================");
//     } else {
//       print("=======================================");
//       print("Facebook login failed");
//       print("=======================================");
//     }
//
//     return null;
//   }
//
//   }

//todo: facebook

// bool isLoggedIn = false;
// late Map user;
//
// void performLogin() async {
//   FacebookAuth.instance.login(
//       permissions: ["public_profile", "email"]).then((value) {
//     FacebookAuth.instance.getUserData().then((result) {
//
//       print("==============================");
//       print(result);
//       print("==============================");
//       isLoggedIn = true;
//       user = result;
//     });
//   });
//
// }
