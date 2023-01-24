// ignore_for_file: avoid_print

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/main.dart';
import 'package:flutter_application_admin_panel/models/model_cart.dart';
import 'package:flutter_application_admin_panel/models/model_order.dart';
import 'package:flutter_application_admin_panel/models/model_user.dart';
import 'package:flutter_application_admin_panel/utilis.dart';

import '../models/model_coupon.dart';

class ManagerPendingOrder extends ChangeNotifier {
  // List userCouponList = [];
  List<ModelUser> usersList = [];
  ModelUser? myAppUser;
  List<ModelCart> productList = [];
  List<ModelOrder> pendingOrderList = [];
  late StreamSubscription<DatabaseEvent> _orderStreamSubscription;

  ManagerPendingOrder() {
    readPendingOrders();
  }

  @override
  void dispose() {
    _orderStreamSubscription.cancel();
    super.dispose();
  }

  /* -------------------------------------------------------------------------- */
  /*                              readPendingOrders                             */
  /* -------------------------------------------------------------------------- */

  readPendingOrders() async {
    print('readPendingOrders: triggered');
    pendingOrderList.clear();
    _orderStreamSubscription = FirebaseDatabase.instance
        .ref()
        .child('pendingOrders')
        .onValue
        .listen((event) async {
      if (event.snapshot.exists) {
        try {
          Map orderMap = Map.from(event.snapshot.value as Map);
          pendingOrderList = orderMap.values.map((e) {
            return ModelOrder.fromMap(Map.from(e));
          }).toList();
          pendingOrderList.sort((a, b) => a.timeStamp!.compareTo(b.timeStamp!));
        } catch (e) {
          print(e);
        }
      } else {
        pendingOrderList.clear();
      }

      await readUsers(); // This is to show the information of the customer in the list
      notifyListeners();
    });
  }

/* -------------------------------- readUsers ------------------------------- */

  readUsers() async {
    usersList = [];
    print('Read Useres Triggered');
    try {
      for (var i = 0; i < pendingOrderList.length; i++) {
        DatabaseReference database = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(pendingOrderList[i].customerId!);

        var event = await database.once();
        myAppUser = ModelUser.fromMap(event.snapshot.value as Map);
        usersList.add(myAppUser!);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

/* -------------------------------------------------------------------------- */
/*                            confirmOrderDelivered                           */
/* -------------------------------------------------------------------------- */

  Future<dynamic> confirmOrderDelivered(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Order Delivered'),
            content: const Text(
                'Are you sure you delivered the order and received the payment ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  var uid = usersList[index].uid;

                  String? orderPushValue =
                      pendingOrderList[index].orderPushValue;

                  await addCouponToUser(uid, index);
                  await useCoupon(uid, index);
                  await updateUserPoints(uid!, pendingOrderList[index]);
                  await removeCouponFormUser(uid, index);

                  await FirebaseDatabase.instance
                      .ref()
                      .child('pendingOrders')
                      .child(orderPushValue!)
                      .update({'orderStatus': 'delivered'});

                  var info = pendingOrderList[index].toMap();

                  await FirebaseDatabase.instance
                      .ref()
                      .child('deliveredOrders')
                      .child(orderPushValue)
                      .set(info);

                  await FirebaseDatabase.instance
                      .ref()
                      .child('pendingOrders')
                      .child(orderPushValue)
                      .remove();

                  Navigator.pop(navigatorKey.currentState!.context);
                },
                child: const Text(
                  'Yes',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

/* -------------------------------------------------------------------------- */
/*                               addCouponToUser                              */
/* -------------------------------------------------------------------------- */

  addCouponToUser(String? userId, int index) async {
    Utils.showDialogMethod('Checking Coupons');

    if (pendingOrderList.isNotEmpty) {
      var length = pendingOrderList[index].orderList!.length;

      for (var i = 0; i < length; i++) {
        if (pendingOrderList[index].orderList![i].isCoupon == true) {
          var noOfCoupons =
              pendingOrderList[index].orderList![i].singleCartQuantity;
          for (var b = 0; b < noOfCoupons; b++) {
            var ref = FirebaseDatabase.instance
                .ref()
                .child('users')
                .child(userId!)
                .child('activeCoupons');

            var customerCouponref = getNewCouponId(userId);

            await ref.child(customerCouponref).set(
                pendingOrderList[index].orderList![i].selectedCoupon!.toMap());

            await ref
                .child(customerCouponref)
                .update({'couponBookId': customerCouponref});
          }
        }
      }
    } else {
      print('pending order list is empty');
    }
    navigatorKey.currentState!.pop();
  }

  String getNewCouponId(String? userId) {
    var couponRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(userId!)
        .child('activeCoupons');

    String newCouponKey = couponRef.push().key!;
    return newCouponKey;
  }

/* -------------------------------------------------------------------------- */
/*                                  useCoupon                                 */
/* -------------------------------------------------------------------------- */
  useCoupon(String? userId, int index) async {
    print('use coupon : trigered');
    Utils.showDialogMethod('updating user Coupons');
    for (var i = 0; i < pendingOrderList[index].orderList!.length; i++) {
      if (pendingOrderList[index].orderList![i].useCoupon == true) {
        var couponId =
            pendingOrderList[index].orderList![i].selectedCoupon!.couponBookId;

        var pendingDelivery1 =
            pendingOrderList[index].orderList![i].singleCartQuantity;

        final ref = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(userId!)
            .child('activeCoupons')
            .child(couponId!);

        var snapshot = await ref.once();
        var dataMap = Map.from(snapshot.snapshot.value as Map);

        var pendingDelivery2 = dataMap['pendingDelivery'];
        var pendingDelivery3 = pendingDelivery2 - pendingDelivery1;

        if (ref.key != null) {
          await FirebaseDatabase.instance
              .ref()
              .child('users')
              .child(userId)
              .child('activeCoupons')
              .child(couponId)
              .update({
            'pendingDelivery': pendingDelivery3,
          });
        } else {
          print('snapshot does not exists');
        }
        navigatorKey.currentState!.popUntil((route) => route.isActive);
      }
    }
    navigatorKey.currentState!.pop();
  }

/* -------------------------------------------------------------------------- */
/*                             confirmCancelOrder                             */
/* -------------------------------------------------------------------------- */
  Future<dynamic> confirmCancelOrder(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Order Cancel'),
              content: const Text('Are you sure to cancel the order ?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    String? value = pendingOrderList[index].orderPushValue;
                    var ref = FirebaseDatabase.instance
                        .ref()
                        .child('pendingOrders')
                        .child(value!);

                    await ref.update({'orderStatus': 'canceled'});
                    await ref.remove();
                    FirebaseDatabase.instance
                        .ref()
                        .child('pendingOrders')
                        .child(value);

                    Navigator.pop(navigatorKey.currentState!.context);
                  },
                  child: const Text(
                    'Yes',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ));
  }

  removeCouponFormUser(String? userId, int index) async {
    Utils.showDialogMethod('Checking User Coupons Quantity');
    print('removeCouponFormUser: triggered');

    for (var i = 0; i < pendingOrderList[index].orderList!.length; i++) {
      if (pendingOrderList[index].orderList![i].useCoupon) {
        var couponId =
            pendingOrderList[index].orderList![i].selectedCoupon!.couponBookId;

        var ref = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(userId!)
            .child('activeCoupons')
            .child(couponId!);

        var refData = await ref.once();
        if (refData.snapshot.exists) {
          var dataValue = Map.from(refData.snapshot.value as Map);
          var availableNum = dataValue['availableCoupons'];
          var pendingDelivery = dataValue['pendingDelivery'];

          if (availableNum == 0 && pendingDelivery == 0) {
            ModelCoupon consumedCoupon =
                pendingOrderList[index].orderList![i].selectedCoupon!;

            await FirebaseDatabase.instance
                .ref()
                .child('users')
                .child(userId)
                .child('consumedCoupons')
                .child(couponId)
                .set(consumedCoupon.toMap());

            await FirebaseDatabase.instance
                .ref()
                .child('users')
                .child(userId)
                .child('activeCoupons')
                .child(couponId)
                .remove();
          } else {
            print('removeCouponFormUser: Coupon still have available numbers');
          }
        } else {
          print('removeCouponFormUser: Coupon is already removed');
        }
      } else {
        print('removeCouponFormUser: no use coupon in order');
      }
    }
    navigatorKey.currentState!.pop();
  }

  updateUserPoints(String uid, ModelOrder order) async {
    Utils.showDialogMethod('Updating User Points');
    print('updateUserPoints: triggered');

    var pointsSnapShot =
        await FirebaseDatabase.instance.ref().child('users').child(uid).once();
    var pointsMap = Map.from(pointsSnapShot.snapshot.value as Map);
    var availPoints = pointsMap['points'];

    for (var i = 0; i < order.orderList!.length; i++) {
      if (order.orderList![i].useOffer) {
        print('no points to update');
      } else {
        await FirebaseDatabase.instance.ref().child('users').child(uid).update(
            {'points': availPoints + order.orderList![i].singleCartPoints});
      }
    }
    navigatorKey.currentState!.pop();
  }
}
