// ignore_for_file: avoid_print

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/main.dart';
import 'package:flutter_application_admin_panel/models/model_order.dart';
import 'package:flutter_application_admin_panel/models/model_user.dart';

class ManagerDelieveredOrder extends ChangeNotifier {
  List<ModelUser> usersList = [];
  ModelUser? myAppUser;
  List<ModelOrder> deliveredOrderList = [];
  late StreamSubscription<DatabaseEvent> _orderStreamSubscription;

  ManagerDelieveredOrder() {
    readDeliveredOrders();
  }

  @override
  void dispose() {
    _orderStreamSubscription.cancel();
    super.dispose();
  }

  readDeliveredOrders() async {
    print('readDeliveredOrders : Trigered');

    deliveredOrderList.clear();
    _orderStreamSubscription = FirebaseDatabase.instance
        .ref()
        .child('deliveredOrders')
        .onValue
        .listen((event) async {
      try {
        if (event.snapshot.exists) {
          var orderMap = Map.from(event.snapshot.value as Map);
          deliveredOrderList = orderMap.values.map((e) {
            return ModelOrder.fromMap(Map.from(e));
          }).toList();
          deliveredOrderList
              .sort((a, b) => a.timeStamp!.compareTo(b.timeStamp!));
        } else {
          deliveredOrderList.clear();
        }
      } catch (e) {
        print(e);
      }
      readUsers();
      notifyListeners();
    });
  }

  readUsers() async {
    usersList.clear();
    print('Read Useres Trigered');
    try {
      for (var i = 0; i < deliveredOrderList.length; i++) {
        DatabaseReference ref = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(deliveredOrderList[i].customerId!);
        var event = await ref.once();
        myAppUser = ModelUser.fromMap(event.snapshot.value as Map);
        usersList.add(myAppUser!);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<dynamic> confirmOrderPending(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Order Not Delivered'),
              content: const Text(
                  'Are you sure you delivered the order was not delivered'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    String? orderPushValue =
                        deliveredOrderList[index].orderPushValue;

                    var ref = FirebaseDatabase.instance
                        .ref()
                        .child('deliveredOrders')
                        .child(orderPushValue!);

                    await ref.update({'orderStatus': 'pending'});

                    var info = deliveredOrderList[index].toMap();
                    await FirebaseDatabase.instance
                        .ref()
                        .child('pendingOrders')
                        .child(orderPushValue)
                        .set(info);

                    await FirebaseDatabase.instance
                        .ref()
                        .child('deliveredOrders')
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
            ));
  }
}
