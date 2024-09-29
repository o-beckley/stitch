import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stitch/models/order_item_model.dart';
import 'package:stitch/models/order_model.dart';

class OrderManagementService extends ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get user => FirebaseAuth.instance.currentUser;
  bool get isSignedIn => user != null;

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

  Future<bool> checkout(List<OrderItem> items) async {
    try{ //TODO
      return false;
    }
    catch(e){
      log("checkout: ${e.toString()}");
      return false;
    }
  }
}