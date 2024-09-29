import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:stitch/models/address_model.dart';
import 'package:stitch/models/order_item_model.dart';
import 'package:stitch/models/user_model.dart';

class UserManagementService extends ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StitchUser? _currentUser;

  StitchUser? get currentUser{
    if(_currentUser == null){
      fetchCurrentUser();
    }
    return _currentUser;
  }

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
      log("hasProfile: ${e.toString()}");
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
    Address? address,
    List<String>? favourites,
    List<OrderItem>? cart
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
        log('updateProfile: profile updated');
        fetchCurrentUser();
        return true;
      }
      else{
        return false;
      }
    }
    catch(e){
      log('updateProfile: ${e.toString()}');
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
      log("getUser: ${e.toString()}");
    }
    return null;
  }

  Future<void> fetchCurrentUser() async {
    /// this function is to be called anytime there are changes to the user
    /// so that _currentUser is updated;
    try{
      if(isSignedIn){
        _currentUser = await getUser(user!.uid);
        notifyListeners();
      }
    }
    catch (e){
      log("fetchCurrentUser: ${e.toString()}");
    }
  }

  Future<bool> addToCart(OrderItem item) async {
    try{
      if(isSignedIn){
        await _userReference.doc(user!.uid).update({
          "cart": FieldValue.arrayUnion([item.toMap()])
        });
        log("addToCart: added ${item.productId} to cart");
        fetchCurrentUser();
        return true;
      }
      else {
        return false;
      }
    }
    catch(e){
      log("addToCart: ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromCart(OrderItem item) async {
    try{
      if(isSignedIn){
        await _userReference.doc(user!.uid).update({
          "cart": FieldValue.arrayRemove([item.toMap()])
        });
        log("removeFromCart: removed ${item.productId} from cart");
        fetchCurrentUser();
        return true;
      }
      else {
        return false;
      }
    }
    catch(e){
      log("removeFromCart: ${e.toString()}");
      return false;
    }
  }

  Future<List<OrderItem>?> getCartItems() async {
    try{
      if(isSignedIn){
        final snapshot = await _userReference.doc(user!.uid).get();
        return snapshot.data()?.cart;
      }
      else {
        return null;
      }
    }
    catch (e) {
      log("getCartItems: ${e.toString()}");
      return null;
    }
  }

  Future<bool> addToFavourites(String productId) async {
    try{
      if(isSignedIn){
        await _userReference.doc(user!.uid).update({
          "favourites": FieldValue.arrayUnion([productId])
        });
        log("addToFavourites: added $productId to favourites");
        fetchCurrentUser();
        return true;
      }
      else{
        return false;
      }
    }
    catch (e){
      log("addToFavourites: ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromFavourites(String productId) async {
    try{
      if(isSignedIn){
        await _userReference.doc(user!.uid).update({
          "favourites": FieldValue.arrayRemove([productId])
        });
        log("removeFromFavourites: removed $productId from favourites");
        fetchCurrentUser();
        return true;
      }
      else{
        return false;
      }
    }
    catch (e){
      log("removeFromFavourites: ${e.toString()}");
      return false;
    }
  }

  bool inFavourites(String productId) {
    try{
      return isSignedIn && currentUser != null && (currentUser?.favourites?.contains(productId) ?? false);
    }
    catch (e){
      log("inFavourites: ${e.toString()}");
      return false;
    }
  }
}