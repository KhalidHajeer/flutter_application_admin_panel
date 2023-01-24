// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/models/model_coupon.dart';

import '../models/model_user.dart';

class ManagerUsers extends ChangeNotifier {
  List<ModelUser> userList = [];
  List<ModelCoupon> usersCouponList = [];
  List<ModelUser> foundUsers = [];

  late StreamSubscription<DatabaseEvent> _userStreamSubscription;
  late StreamSubscription<DatabaseEvent> _couponStreamSubscription;

  TextEditingController controllerSearch = TextEditingController();

  ManagerUsers(BuildContext context) {
    listenToUsers(context);
  }

  @override
  void dispose() {
    _userStreamSubscription.cancel();
    _couponStreamSubscription.cancel();

    super.dispose();
  }

  listenToUsers(BuildContext context) {
    print('listenToUsers : triggered');
    _userStreamSubscription = FirebaseDatabase.instance
        .ref()
        .child('users')
        .onValue
        .listen((event) async {
      if (event.snapshot.exists) {
        var usersMap = event.snapshot.value as Map;
        userList = usersMap.values.map((e) {
          return ModelUser.fromMap(Map.from(e));
        }).toList();

        userList.sort(
          (a, b) => a.name!.compareTo(b.name!),
        );
        if (controllerSearch.text != '') {
          runFilter(userList, controllerSearch.text);
        }
      } else {
        userList.clear();
      }
      notifyListeners();
    });
  }

  runFilter(List<ModelUser> userList, String enteredKeyword) {
    print('runFilter: triggered');

    searchPhone() {
      print('searchPhone: triggered');
      foundUsers = userList
          .where((user) => user.phoneNumber!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList(); // we use the toLowerCase() method to make it case-insensitive
    }

    searchName() {
      print('searchName: triggered');
      foundUsers = userList
          .where((user) => '${user.name}'
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList(); // we use the toLowerCase() method to make it case-insensitive
    }

    if (enteredKeyword.isEmpty) {
      foundUsers = [];
    } else {
      if (enteredKeyword[0] == '+' || enteredKeyword[0] == '$num') {
        searchPhone();
      } else {
        try {
          int.parse(enteredKeyword);
          searchPhone();
        } catch (e) {
          searchName();
        }
      }
    }
    notifyListeners();
  }
}
