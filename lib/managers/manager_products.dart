// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/main.dart';

import '../utilis.dart';
import '../models/model_product.dart';

class ManagerProducts extends ChangeNotifier {
  DatabaseReference database = FirebaseDatabase.instance.ref();

  List<ModelProduct> productList = [];
  String errorMassage = '';
  var productsPriceAdd = 0.0;

  late StreamSubscription<DatabaseEvent> _productStreamSubscription;
  List<ModelProduct> allProductList = [];

  @override
  void dispose() {
    _productStreamSubscription.cancel();
    super.dispose();
  }

/* ----------------------------- delete product ----------------------------- */

  deleteProducts(int index, String path) {
    if (productList.length == 1) {
      database.child('products').child(path).remove();
      productList.removeAt(index);
    } else {
      database.child('products').child(path).remove();
    }
    notifyListeners();
    Utils.showSnackBar('Selected Product is Deleted');
  }

/* --------------------------- delete all products -------------------------- */

  deleteAllProducts() {
    Utils.showSnackBar('App Products Were deleted');
    try {
      database.child('products').remove();
      productList.clear();
    } catch (e) {
      if (kDebugMode) {
        print('You got an error $e');
      }
    }
    notifyListeners();
  }

  String getNewProductPushKey() {
    String orderPushKey = database.child('products').push().key!;
    return orderPushKey;
  }

  addNewProduct(ModelProduct product, String orderPushKey) async {
    DatabaseReference productRef = database.child('products');
    Utils.showDialogMethod('adding new product');
    try {
      await productRef.child(orderPushKey).set(product.toMap());
      Utils.showSnackBar('New Product Has Been Added');
      Navigator.pop(navigatorKey.currentState!.context);
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.pop();
    notifyListeners();
  }

  readAllProducts() {
    print('readAllProducts: Triggered');
    try {
      _productStreamSubscription = FirebaseDatabase.instance
          .ref()
          .child('products')
          .onValue
          .listen((event) {
        Map couponsMap = Map.from(event.snapshot.value as Map);
        allProductList = couponsMap.values.map((e) {
          return ModelProduct.fromMap(Map.from(e));
        }).toList();
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  updateProduct(ModelProduct product) async {
    print('updateCoupon: triggered');

    DatabaseReference couponRef =
        database.child('products').child(product.key!);

    Utils.showDialogMethod('updating product');
    try {
      await couponRef.set(product.toMap());
      Utils.showSnackBar('product info has been updated');
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.pop();
    Navigator.pop(navigatorKey.currentState!.context);
    notifyListeners();
  }
}
