// ignore_for_file: public_member_api_docs, sort_constructors_first

class ModelProduct {
  String? key;
  String? description;
  String? details;
  String? imageURL;
  int? points;
  num? productPrice;

  ModelProduct({
    this.key,
    this.description,
    this.details,
    this.imageURL,
    this.points,
    this.productPrice,
  });

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      'key': key,
      'description': description,
      'details': details,
      'imageURL': imageURL,
      'points': points,
      'productPrice': productPrice,
    };
  }

  factory ModelProduct.fromMap(Map<dynamic, dynamic> map) {
    return ModelProduct(
      key: map['key'] != null ? map['key'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : '',
      details: map['details'] != null ? map['details'] as String : '',
      imageURL: map['imageURL'] != null ? map['imageURL'] as String : '',
      points: map['points'] != null ? map['points'] as int : 0,
      productPrice:
          map['productPrice'] != null ? map['productPrice'] as num : 0,
    );
  }
}