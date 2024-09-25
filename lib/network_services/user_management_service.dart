import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:stitch/models/user_model.dart';

class UserManagementService extends ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get user => FirebaseAuth.instance.currentUser;
  bool get isSignedIn => user != null;

  CollectionReference<StitchUser> get _userReference => _firestore
    .collection('users')
    .withConverter(
      fromFirestore: (value, options){
        var v = value.data()!;
        v.addAll({'id': value.id});
        return StitchUser.fromMap(v);
      },
      toFirestore: (value, options){
        var v = value.toMap();
        v.remove('id');
        return v;
      }
  );

  Future<bool> get hasProfile async {
    try{
      if(isSignedIn){
        final snapshot = await _userReference.doc(user!.uid).get();
        return snapshot.exists;
      }
      else {
        return false;
      }
    }
    catch(e){
      log("UserManagementService.hasProfile: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    Gender? gender,
    AgeGroup? ageGroup,
    String? address,
    List<String>? favourites,
    List<String>? cart
  }) async {
    try{
      if(isSignedIn){
        final snapshot = await _userReference.doc(user!.uid).get();
        final oldProfile = snapshot.data() ?? StitchUser(id: user!.uid);
        final newProfile = oldProfile.copyWith(
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          email: email,
          gender: gender,
          ageGroup: ageGroup,
          address: address,
          favourites: favourites,
          cart: cart,
        );
        await _userReference.doc(user!.uid).set(newProfile);
        log('UserManagementService.updateProfile: profile updated');
        return true;
      }
      else{
        return false;
      }
    }
    catch(e){
      log('UserManagementService.updateProfile: ${e.toString()}');
      return false;
    }
  }

  Future<StitchUser?> getUser(String id) async {
    try{
      if(isSignedIn){
        final snapshot = await _userReference.doc(id).get();
        return snapshot.data();
      }
    }
    catch(e){
      log("UserManagementService.getUser: ${e.toString()}");
    }
    return null;
  }
}