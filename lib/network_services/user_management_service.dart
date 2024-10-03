import 'dart:developer';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:stitch/models/address_model.dart';
import 'package:stitch/models/delivery_details_model.dart';
import 'package:stitch/models/order_item_model.dart';
import 'package:stitch/models/order_model.dart';
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

  CollectionReference<StitchOrder> get _ordersReference => _firestore
      .collection('orders')
      .withConverter(
      fromFirestore: (value, options){
        var v = value.data()!;
        v.addAll({'id': value.id});
        return StitchOrder.fromMap(v);
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

  Future<List<StitchOrder>?> getOrders() async {
    try{
      final orderIds = currentUser?.orderIds;
      if(orderIds != null && orderIds.isNotEmpty){
        final snapshot = await _ordersReference
            .where(FieldPath.documentId, whereIn: orderIds).get();
        return snapshot.docs.map((e) => e.data()).toList();
      }
      else{
        return null;
      }
    }
    catch(e){
      log("getOrders: ${e.toString()}");
      return null;
    }
  }

  Future<String?> get _createOrderId async {
    try {
      final int milliseconds = DateTime
          .now()
          .millisecondsSinceEpoch;
      final random = math.Random();
      final rand = random.nextInt(4096);
      String id = "$milliseconds${rand.toString().padLeft(4, '0')}";
      final ref = await _ordersReference.doc(id).get();
      if (ref.exists) {
        return _createOrderId;
      }
      return id;
    }
    catch(e){
      log("_createOrderId: ${e.toString()}");
      return null;
    }
  }

  Future<bool> checkout({
    required List<OrderItem> orderItems,
    required DeliveryDetails deliveryDetails,
  }) async {
    /// This function should be called after a payment has been made.
    try{
      if(isSignedIn && orderItems.isNotEmpty) {
        List<String> sellers = [];
        for (OrderItem item in orderItems){
          if(!sellers.contains(item.sellerId)){
            sellers.add(item.sellerId);
          }
        }
        for (String sellerId in sellers){ // Grouping each order by seller.
          final items = orderItems.where((i) => i.sellerId == sellerId).toList();
          final order = StitchOrder(
              sellerId: sellerId,
              receiverId: user!.uid,
              status: {OrderStatus.placed: DateTime.now()},
              deliveryDetails: deliveryDetails,
              items: items
          );
          final String? id = await _createOrderId;
          if(id == null){
            return false;
          }
          await _ordersReference.doc(id).set(order);
          await _userReference.doc(user!.uid).update({
            'orderIds': FieldValue.arrayUnion([id]),
            'cart': FieldValue.arrayRemove(items.map((e) => e.toMap()).toList())
          });
          log("checkout: ${items.length} items from $sellerId have been checked out");
        }
        fetchCurrentUser();
        return true;
      }
      else{
        return false;
      }
    }
    catch(e){
      log("checkout: ${e.toString()}");
      return false;
    }
  }
}