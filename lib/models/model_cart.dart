// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'model_coupon.dart';
import 'model_product.dart';
import 'model_offers.dart';

class ModelCart {
  String key = '';
  String singleCartDescription = '';
  num itemPrice = 0;
  num itemPoints = 0;
  num singleCartPrice = 0;
  num singleCartQuantity = 0;
  String singleCartImageURL = '';
  num singleCartPoints = 0;
  bool isCoupon = false;
  bool useCoupon = false;
  bool useOffer = false;
  ModelCoupon? selectedCoupon;
  ModelProduct? selectedProduct;
  ModelOffers? selectedOffer;

  ModelCart({
    required this.key,
    required this.singleCartDescription,
    required this.itemPrice,
    required this.itemPoints,
    required this.singleCartPrice,
    required this.singleCartQuantity,
    required this.singleCartImageURL,
    required this.singleCartPoints,
    required this.isCoupon,
    required this.useCoupon,
    required this.useOffer,
    this.selectedCoupon,
    this.selectedProduct,
    this.selectedOffer,
  });

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      'key': key,
      'singleCartDescription': singleCartDescription,
      'itemPrice': itemPrice,
      'itemPoints': itemPoints,
      'singleCartPrice': singleCartPrice,
      'singleCartQuantity': singleCartQuantity,
      'singleCartImageURL': singleCartImageURL,
      'singleCartPoints': singleCartPoints,
      'isCoupon': isCoupon,
      'useCoupon': useCoupon,
      'selectedCoupon': selectedCoupon?.toMap(),
      'selectedProduct': selectedProduct?.toMap(),
      'selectedOffer': selectedOffer?.toMap(),
      'useOffer': useOffer,
    };
  }

  factory ModelCart.fromMap(Map<dynamic, dynamic> map) {
    return ModelCart(
      key: map['key'] as String,
      singleCartDescription: map['singleCartDescription'] as String,
      itemPrice: map['itemPrice'] as num,
      itemPoints: map['itemPoints'] as num,
      singleCartPrice: map['singleCartPrice'] as num,
      singleCartQuantity: map['singleCartQuantity'] as num,
      singleCartImageURL: map['singleCartImageURL'] as String,
      singleCartPoints: map['singleCartPoints'] as num,
      isCoupon: map['isCoupon'] as bool,
      selectedCoupon: map['selectedCoupon'] != null
          ? ModelCoupon.fromMap(map['selectedCoupon'] as Map<dynamic, dynamic>)
          : null,
      selectedProduct: map['selectedProduct'] != null
          ? ModelProduct.fromMap(
              map['selectedProduct'] as Map<dynamic, dynamic>)
          : null,
      selectedOffer: map['selectedOffer'] != null
          ? ModelOffers.fromMap(map['selectedOffer'] as Map<dynamic, dynamic>)
          : null,
      useCoupon: map['useCoupon'] as bool,
      useOffer: map['useOffer'] as bool,
    );
  }
}
