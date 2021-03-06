import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotVerifiedException implements Exception {}

class AuthService with ChangeNotifier {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;


  ///
  /// return the Future with firebase user object FirebaseAuth.User if one exists
  ///
  Future<auth.User> getUser() {
    return Future<auth.User>.value(_auth.currentUser);
  }

  auth.User getUserAsync() {
    return _auth.currentUser;
  }

  // wrapping the firebase calls
  Future logout() async {
    var result = await _auth.signOut();

    notifyListeners();
    return result;
  }

  // wrapping the firebase calls
  Future createUser({String firstName = "",
    String lastName = "",
    String email,
    String password}) async {
    var r = await auth.FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    var u = r.user;

    return await u.updateProfile(displayName: firstName);
  }


  ///
  /// wrapping the firebase call to signInWithEmailAndPassword
  /// `email` String
  /// `password` String
  ///
  Future<auth.User> loginUser({String email, String password}) async {
    try {
      var result = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      notifyListeners();
      return result.user;
    } on PlatformException catch (e) {
      //print(e.message);
      throw auth.FirebaseAuthException(message: e.message, code: e.code);
    }
    catch (e) {
      throw auth.FirebaseAuthException(message: e.message ?? "", code: e.code);
    }
  }
}
