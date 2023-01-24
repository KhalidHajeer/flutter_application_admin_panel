// ignore_for_file: public_member_api_docs, sort_constructors_first

class ModelCoupon {
  String? key;
  String? couponBookId;

  String? couponBookTitle;
  String? imageURL;
  String? couponBookDescription;
  String product;

  num? couponBookPoints;
  num? couponBookPrice;

  int? availableCoupons;
  int? usedCoupons;
  int? pendingDelivery;

  ModelCoupon({
    this.key,
    this.couponBookId,
    this.couponBookTitle,
    this.imageURL,
    this.couponBookDescription,
    required this.product,
    this.couponBookPrice,
    this.couponBookPoints,
    this.availableCoupons,
    this.usedCoupons,
    this.pendingDelivery,
  });

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      'key': key,
      'couponBookId': couponBookId,
      'couponBookTitle': couponBookTitle,
      'imageURL': imageURL,
      'couponBookDescription': couponBookDescription,
      'product': product,
      'couponBookPrice': couponBookPrice,
      'couponBookPoints': couponBookPoints,
      'availableCoupons': availableCoupons,
      'usedCoupons': usedCoupons,
      'pendingDelivery': pendingDelivery
    };
  }

  factory ModelCoupon.fromMap(Map<dynamic, dynamic> map) {
    return ModelCoupon(
      key: map['key'] != null ? map['key'] as String : '',
      couponBookId:
          map['couponBookId'] != null ? map['couponBookId'] as String : '',
      couponBookTitle: map['couponBookTitle'] != null
          ? map['couponBookTitle'] as String
          : '',
      imageURL: map['imageURL'] != null ? map['imageURL'] as String : '',
      couponBookDescription: map['couponBookDescription'] != null
          ? map['couponBookDescription'] as String
          : '',
      product: map['product'] != null ? map['product'] as String : '',
      availableCoupons:
          map['availableCoupons'] != null ? map['availableCoupons'] as int : 0,
      pendingDelivery:
          map['pendingDelivery'] != null ? map['pendingDelivery'] as int : 0,
      usedCoupons: map['usedCoupons'] != null ? map['usedCoupons'] as int : 0,
      couponBookPrice:
          map['couponBookPrice'] != null ? map['couponBookPrice'] as num : 0,
      couponBookPoints:
          map['couponBookPoints'] != null ? map['couponBookPoints'] as num : 0,
    );
  }
}
