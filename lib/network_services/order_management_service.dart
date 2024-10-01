import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stitch/models/delivery_details_model.dart';
import 'package:stitch/models/order_item_model.dart';
import 'package:stitch/models/order_model.dart';
import 'package:stitch/models/user_model.dart';

class OrderManagementService extends ChangeNotifier{
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

  Future<bool> checkout({
    required List<OrderItem> orderItems,
    required DeliveryDetails deliveryDetails,
  }) async {
    /// This function should be called after a payment has been made.
    try{
      if(isSignedIn) {
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
          final ref = await _ordersReference.add(order);
          await _userReference.doc(user!.uid).update({
            'orders': FieldValue.arrayUnion([ref.id]),
            'cart': FieldValue.arrayRemove(items.map((e) => e.toMap()).toList())
          });
          log("checkout: ${items.length} items from $sellerId have been checked out");
        }
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