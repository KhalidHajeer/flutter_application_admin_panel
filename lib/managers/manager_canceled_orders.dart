// ignore_for_file: avoid_print

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/models/model_order.dart';
import 'package:flutter_application_admin_panel/models/model_user.dart';

class ManagerCanceledOrders extends ChangeNotifier {
  List<ModelUser> usersList = [];
  ModelUser? myAppUser;
  List<ModelOrder> canceledOrderList = [];
  late StreamSubscription<DatabaseEvent> _orderStreamSubscription;

  ManagerCanceledOrders() {
    readCanceledOrders();
  }

  @override
  void dispose() {
    _orderStreamSubscription.cancel();
    super.dispose();
  }

  readCanceledOrders() async {
    canceledOrderList.clear();
    _orderStreamSubscription = FirebaseDatabase.instance
        .ref()
        .child('orders')
        .orderByChild('orderStatus')
        .equalTo('canceled')
        .onValue
        .listen((event) async {
      if (event.snapshot.exists) {
        try {
          Map orderMap = Map.from(event.snapshot.value as Map);
          canceledOrderList = orderMap.values.map((e) {
            return ModelOrder.fromMap(Map.from(e));
          }).toList();
          canceledOrderList
              .sort((a, b) => a.timeStamp!.compareTo(b.timeStamp!));
        } catch (e) {
          print(e);
        }
      } else {
        canceledOrderList.clear();
      }

      // readUsers();
      notifyListeners();
    });
  }

  // readUsers() async {
  //   usersList.clear();
  //   print('Read Useres Trigered');
  //   try {
  //     for (var i = 0; i < canceledOrderList.length; i++) {
  //       DatabaseReference database = FirebaseDatabase.instance
  //           .ref()
  //           .child('users')
  //           .child(canceledOrderList[i].customerId!);
  //       var event = await database.once();
  //       myAppUser = ModelUser.fromMap(event.snapshot.value as Map);
  //       usersList.add(myAppUser!);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   notifyListeners();
  // }
}
