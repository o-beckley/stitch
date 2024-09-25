import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier{
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get user => FirebaseAuth.instance.currentUser;
  bool get isSignedIn => user != null;

  Future<bool> signIn(String email, String password) async {
    try{
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if(credential.user != null){
        log("AuthService.signIn: signed in");
        return true;
      }
      else{
        return false;
      }
    }
    catch(e){
      log("AuthService.signIn: ${e.toString()}");
      return false;
    }
  }

  Future<bool> createAccount(String email, String password) async {
    try{
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if(credential.user != null){
        log('AuthService.createAccount: account created');
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
        return true;
      }
      else{
        return false;
      }
    }
    catch(e){
      log("AuthService.createAccount: ${e.toString()}");
      return false;
    }
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
        log('AuthService.signInWithGoogle: signed in');
        return true;
      }
      else {
        log('AuthService.signInWithGoogle: something went wrong');
        return false;
      }
    }
    catch (e){
      log("AuthService.signInWithGoogle: ${e.toString()}");
      return false;
    }
  }

  Future<bool> signInSilently() async {
    try {
      final googleSignInAccount = await _googleSignIn.signInSilently();
      return googleSignInAccount != null;
    }
    catch (e){
      log("AuthService.signInSilently: ${e.toString()}");
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    }
    catch(e){
      log("AuthService.sendPasswordResetEmail: ${e.toString()}");
      return true;
    }
  }

  Future<bool> signOut() async {
    try{
      await FirebaseAuth.instance.signOut();
      log('AuthService.signOut: signed out');
      return true;
    }
    catch(e){
      log("AuthService.signOut: ${e.toString()}");
      return false;
    }
  }
}