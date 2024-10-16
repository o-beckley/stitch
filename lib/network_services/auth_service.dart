import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService extends ChangeNotifier{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final database = FirebaseDatabase.instance;

  User? get user => FirebaseAuth.instance.currentUser;
  Stream<User?> get userChanges => FirebaseAuth.instance.userChanges();
  bool get isSignedIn => user != null;

  Future<bool> signIn(String email, String password) async {
    try{
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if(credential.user != null){
        log("signIn: signed in");
        return true;
      }
      else{
        return false;
      }
    }
    catch(e){
      log("signIn: ${e.toString()}");
      return false;
    }
  }

  Future<bool> createAccount(String email, String password) async {
    try{
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if(credential.user != null){
        log('createAccount: account created');
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
        return true;
      }
      else{
        return false;
      }
    }
    catch(e){
      log("createAccount: ${e.toString()}");
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
        log('signInWithGoogle: signed in');
        return true;
      }
      else {
        log('signInWithGoogle: something went wrong');
        return false;
      }
    }
    catch (e){
      log("signInWithGoogle: ${e.toString()}");
      return false;
    }
  }

  Future<bool> signInSilently() async {
    try {
      final googleSignInAccount = await _googleSignIn.signInSilently();
      log("signInSilently: ${googleSignInAccount != null ? "signed in with stealth :)" : "could not sign in"}");
      return googleSignInAccount != null;
    }
    catch (e){
      log("signInSilently: ${e.toString()}");
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    }
    catch(e){
      log("sendPasswordResetEmail: ${e.toString()}");
      return true;
    }
  }

  void handlePresence(){
    try {
      database
      .ref()
      .child(".info/connected")
      .onValue
      .listen(
        (e) async {
          final connected = e.snapshot.value as bool? ?? false;
          if (isSignedIn && connected) {
            await database.ref("connection_status/${user!.uid}").update({
              "state": "connected",
              "last_changed": ServerValue.timestamp
            });
            await database.ref("connection_status/${user!.uid}").onDisconnect().update({
              "state": "disconnected",
              "last_changed": ServerValue.timestamp
            });
          }
        }
      );
    }
    catch(e){
      log("handlePresence: ${e.toString()}");
    }
  }

  Future<bool> signOut() async {
    try{
      await FirebaseAuth.instance.signOut();
      log('signOut: signed out');
      return true;
    }
    catch(e){
      log("signOut: ${e.toString()}");
      return false;
    }
  }
}