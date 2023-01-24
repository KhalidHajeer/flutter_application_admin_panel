// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'model_cart.dart';

enum OrderStatus { delivered, pending, canceled }

const orderStatusEnumMap = {
  OrderStatus.delivered: 'delivered',
  OrderStatus.pending: 'pending',
  OrderStatus.canceled: 'canceled',
};

class ModelOrder {
  String? orderId = '';
  String? orderPushValue;
  DateTime? timeStamp = DateTime.now();
  String? customerId = '';
  List<ModelCart>? orderList = [];
  String? orderNotes = '';
  num? totalOrderPrice = 0;
  num? totalOrderPoints = 0;
  // enum
  OrderStatus? orderStatus = OrderStatus.pending;

  ModelOrder({
    this.orderId,
    this.orderPushValue,
    this.timeStamp,
    this.customerId,
    this.orderList,
    this.orderNotes,
    this.totalOrderPrice,
    this.totalOrderPoints,
    this.orderStatus,
  });

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      'orderId': orderId,
      'orderPushValue': orderPushValue,
      'customerId': customerId!,
      'timeStamp': timeStamp!.millisecondsSinceEpoch,
      'orderList': orderList!.map((x) => x.toMap()).toList(),
      'orderNotes': orderNotes,
      'totalOrderPrice': totalOrderPrice,
      'totalOrderPoints': totalOrderPoints,
      'orderStatus': orderStatusEnumMap[orderStatus],
    };
  }

  factory ModelOrder.fromMap(Map<dynamic, dynamic> map) {
    return ModelOrder(
        customerId: map['customerId'],
        orderPushValue: map['orderPushValue'],
        orderId: map['orderId'],
        timeStamp: (map['timeStamp'] != null)
            ? DateTime.fromMillisecondsSinceEpoch(map['timeStamp'])
            : DateTime.now(),
        orderList: map['orderList'] != null
            ? List<ModelCart>.from(
                (map['orderList'] as List).map<ModelCart?>(
                  (x) => ModelCart.fromMap(x as Map<dynamic, dynamic>),
                ),
              )
            : null,
        orderNotes:
            map['orderNotes'] != null ? map['orderNotes'] as String : null,
        totalOrderPrice: map['totalOrderPrice'] != null
            ? map['totalOrderPrice'] as num
            : null,
        totalOrderPoints: map['totalOrderPoints'] != null
            ? map['totalOrderPoints'] as num
            : null,
        orderStatus:
            $enumDecodeNullable(orderStatusEnumMap, map['orderStatus']));
  }

  String toJson() => json.encode(toMap());

  factory ModelOrder.fromJson(String source) =>
      ModelOrder.fromMap(json.decode(source) as Map<dynamic, dynamic>);
}
