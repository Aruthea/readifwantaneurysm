import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth with ChangeNotifier {
  late final String _token =
      FirebaseAuth.instance.currentUser!.refreshToken.toString();
  late final String _userId = FirebaseAuth.instance.currentUser!.uid.toString();
  bool _authed = false;

  bool get authed {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        log('User is currently signed out!');
        _authed = false;
      } else {
        log('User is signed in!');
        _authed = true;
      }
    });
    return _authed;
  }

  String? get token {
    return _token;
  }

  String get userId {
    return _userId;
  }

  // Future<bool> tryAutoLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('userData')) {
  //     return false;
  //   }
  //   final extractedUserData =
  //       json.decode(prefs.getString('userData').toString());
  //   final expiryDate =
  //       DateTime.parse(extractedUserData['expiryDate'].toString());
  //   if (expiryDate.isBefore(DateTime.now())) {
  //     return false;
  //   }
  //   _token = extractedUserData['token'];
  //   _userId = extractedUserData['userId'];
  //   _expiryDate = expiryDate;
  //   notifyListeners();
  //   return true;
  // }

  // Future<void> logout() async {
  //   FirebaseAuth.instance.signOut();
  //   // await GoogleSignIn().signOut();
  // }

  // void _autoLogout() {
  //   if (_authTimer != null) {
  //     _authTimer!.cancel();
  //   }
  //   final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  // }
}

class UserController {
  static User? user = FirebaseAuth.instance.currentUser;
  static Future<User?> loginWithGoogle() async {
    final googleAccount = await GoogleSignIn().signIn();
    final googleAuth = await googleAccount?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;
  }
}
