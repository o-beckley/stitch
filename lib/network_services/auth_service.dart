import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier{
  User? get user => FirebaseAuth.instance.currentUser;
  bool get isSignedIm => user != null;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    return false;
  }

  Future<bool> signInWithGoogle() async {
    try{
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(authCredential);
      if (userCredential.user != null){
        log('signed in');
        return true;
      }
      else {
        log('something went wrong');
        return false;
      }
    }
    catch (e){
      log(e.toString());
      return false;
    }
  }

  Future<bool> signInSilently() async {
    try {
      final googleSignInAccount = await _googleSignIn.signInSilently();
      return googleSignInAccount != null;
    }
    catch (e){
      log(e.toString());
      return false;
    }
  }

  Future<bool> signOut() async {
    try{
      await FirebaseAuth.instance.signOut();
      log('signed out');
      return true;
    }
    catch(e){
      log(e.toString());
      return false;
    }
  }
}