import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stitch/models/product_model.dart';
import 'package:stitch/models/seller_model.dart';

class ProductProviderService extends ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get user => FirebaseAuth.instance.currentUser;
  bool get isSignedIn => user != null;

  CollectionReference<StitchSeller> get _sellerReference => _firestore
      .collection('sellers')
      .withConverter(
      fromFirestore: (value, options){
        var v = value.data()!;
        v.addAll({'id': value.id});
        return StitchSeller.fromMap(v);
      },
      toFirestore: (value, options){
        var v = value.toMap();
        v.remove('id');
        return v;
      }
  );
  CollectionReference<Product> get _productReference => _firestore
      .collection('products')
      .withConverter(
      fromFirestore: (value, options){
        var v = value.data()!;
        v.addAll({'id': value.id});
        return Product.fromMap(v);
      },
      toFirestore: (value, options){
        var v = value.toMap();
        v.remove('id');
        return v;
      }
  );

  Future<StitchSeller?> getSeller(String id) async {
    try{
      if(isSignedIn){
        final snapshot = await _sellerReference.doc(id).get();
        return snapshot.data();
      }
    }
    catch(e){
      log("getSeller: ${e.toString()}");
    }
    return null;
  }

  Future<Product?> getProduct(String id) async {
    try{
      if(isSignedIn){
        final snapshot = await _productReference.doc(id).get();
        return snapshot.data();
      }
    }
    catch(e){
      log("getProduct: ${e.toString()}");
    }
    return null;
  }
}