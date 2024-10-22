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

  Future<QuerySnapshot<Product>?> getProducts({
    required Gender gender,
    DocumentSnapshot? lastQuerySnapshot,
    int limit = 30
  }) async {
    try {
      if(lastQuerySnapshot != null){
        return _productReference
          .where("genders", arrayContains: gender.name)
          .startAtDocument(lastQuerySnapshot)
          .limit(limit)
          .get();
      }
      else{
        return _productReference
          .where("genders", arrayContains: gender.name)
          .limit(limit)
          .get();
      }
    }
    catch(e){
      log("getProducts: ${e.toString()}");
    }
    return null;
  }

  Future<QuerySnapshot<Product>?> search( //TODO: create better search
      String query,
      {DocumentSnapshot? lastQuerySnapshot, int limit = 30}) async {
    if(query.isNotEmpty){
      try {
        if(lastQuerySnapshot != null){
          return _productReference
            .where("name", arrayContains: query)
            .startAtDocument(lastQuerySnapshot)
            .limit(limit)
            .get();
        }
        else{
          return _productReference
            .where("name", isGreaterThanOrEqualTo: query)
            .where("name", isLessThanOrEqualTo: "$query~")
            .limit(limit)
            .get();
        }
      }
      catch(e){
        log("search: ${e.toString()}");
      }
    }
    return null;
  }
}