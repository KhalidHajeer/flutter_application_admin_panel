// ignore_for_file: avoid_print

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/main.dart';
import 'package:flutter_application_admin_panel/models/model_offers.dart';
import 'package:flutter_application_admin_panel/utilis.dart';

class ManagerOffers extends ChangeNotifier {
  late StreamSubscription<DatabaseEvent> _offerStreamSubscription;
  List<ModelOffers> offerList = [];

  ManagerOffers() {
    readOffers();
  }

  @override
  void dispose() {
    _offerStreamSubscription.cancel();
    super.dispose();
  }

  creatNewOffer(ModelOffers modelPoints, String offerPushKey) {
    Utils.showDialogMethod('Placing new offer into Data Base');
    FirebaseDatabase.instance
        .ref()
        .child('offers')
        .child(offerPushKey)
        .set(modelPoints.toMap());
    navigatorKey.currentState!.pop();
    navigatorKey.currentState!.pop();
  }

  String getNewOfferPushKey() {
    String offerPushKey =
        FirebaseDatabase.instance.ref().child('offers').push().key!;
    return offerPushKey;
  }

  readOffers() {
    print('read offers : Triggered');
    try {
      _offerStreamSubscription = FirebaseDatabase.instance
          .ref()
          .child('offers')
          .onValue
          .listen((event) {
        if (event.snapshot.exists) {
          Map offersMap = Map.from(event.snapshot.value as Map);
          offerList = offersMap.values.map((e) {
            return ModelOffers.fromMap(Map.from(e));
          }).toList();
          notifyListeners();
        } else {
          offerList = [];
          print('Snapshot does not exicts');
        }
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  updateOffer(ModelOffers offer) async {
    print('updateCoupon: triggered');

    DatabaseReference offerRef =
        FirebaseDatabase.instance.ref().child('offers').child(offer.id);

    Utils.showDialogMethod('updating coupon');
    try {
      await offerRef.set(offer.toMap());
      Utils.showSnackBar('offer has been updated');
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.pop();
    Navigator.pop(navigatorKey.currentState!.context);
    notifyListeners();
  }
}
