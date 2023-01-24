// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/managers/manager_users.dart';
import 'package:flutter_application_admin_panel/models/model_user.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../utilis.dart';
import '../models/model_coupon.dart';

class ManagerCoupons extends ChangeNotifier {
  DatabaseReference database = FirebaseDatabase.instance.ref();

  List<ModelCoupon> couponsList = [];
  List<ModelCoupon> couponsProductList = [];

  String errorMassage = '';
  var couponsPriceAdd = 0.0;
  List<ModelCoupon> usersCouponList = [];

  late StreamSubscription<DatabaseEvent> _couponsStreamSubscription;
  @override
  void dispose() {
    _couponsStreamSubscription.cancel();
    super.dispose();
  }

  ManagerCoupons() {
    getAllUserCoupons();
  }

/* ------------------------- getAllCoupons -------------------------------- */
  getAllUserCoupons() async {
    usersCouponList = [];
    print('getAllCoupons: Triggered');

    var userList = Provider.of<ManagerUsers>(navigatorKey.currentState!.context,
            listen: false)
        .userList;
    for (var i = 0; i < userList.length; i++) {
      var value = await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child('${userList[i].uid}')
          .child('activeCoupons')
          .once();
      if (value.snapshot.exists) {
        var map = Map.from(value.snapshot.value as Map);
        var tempUsersCouponList =
            map.values.map((e) => ModelCoupon.fromMap(e)).toList();
        usersCouponList.addAll(tempUsersCouponList);
      }
    }
    notifyListeners();
  }
/* ----------------------------- delete coupon ----------------------------- */

  deleteCoupons(int index, String path) {
    if (couponsList.length == 1) {
      database.child('coupons').child(path).remove();
      couponsList.removeAt(index);
    } else {
      database.child('coupons').child(path).remove();
    }
    notifyListeners();
    Utils.showSnackBar('Selected coupons is Deleted');
  }

  String getNewCouponPushKey() {
    String couponPushKey = database.child('coupons').push().key!;
    return couponPushKey;
  }

  createNewCoupon(ModelCoupon coupon, String couponPushKey) async {
    print('createNewCoupon: triggered');
    DatabaseReference couponRef = database.child('coupons');
    Utils.showDialogMethod('adding new coupon');
    try {
      await couponRef.child(couponPushKey).set(coupon.toMap());
      Utils.showSnackBar('New coupon Has Been Added');
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.pop();
    Navigator.pop(navigatorKey.currentState!.context);
    notifyListeners();
  }

  updateCoupon(ModelCoupon coupon) async {
    print('updateCoupon: triggered');

    DatabaseReference couponRef = database.child('coupons').child(coupon.key!);

    Utils.showDialogMethod('updating coupon');
    try {
      await couponRef.set(coupon.toMap());
      Utils.showSnackBar('New coupon Has Been Added');
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.pop();
    Navigator.pop(navigatorKey.currentState!.context);
    notifyListeners();
  }

  readProductCoupons() {
    print('readProductCoupons: Triggered');
    try {
      _couponsStreamSubscription = FirebaseDatabase.instance
          .ref()
          .child('coupons')
          .onValue
          .listen((event) {
        if (event.snapshot.exists) {
          Map couponsMap = Map.from(event.snapshot.value as Map);
          couponsProductList = couponsMap.values.map((e) {
            return ModelCoupon.fromMap(Map.from(e));
          }).toList();
          notifyListeners();
        } else {
          couponsProductList = [];
          print('Snapshot does not exicts');
        }
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  addCouponToUser(
      {required ModelCoupon coupon, required ModelUser user}) async {
    Utils.showDialogMethod('Updating User Coupons');

    String getNewCouponId(String? userId) {
      var couponRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userId!)
          .child('activeCoupons');
      String newCouponKey = couponRef.push().key!;
      return newCouponKey;
    }

    var ref = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(user.uid!)
        .child('activeCoupons');

    var newCouponKey = getNewCouponId(user.uid!);

    await ref.child(newCouponKey).set(coupon.toMap());
    await ref.child(newCouponKey).update({'couponBookId': newCouponKey});

    navigatorKey.currentState!.popUntil(
      (route) => route.isFirst,
    );
    Utils.showSnackBar('New Coupon is added to ${user.name}');
  }
}
