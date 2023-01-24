
// ignore_for_file: public_member_api_docs, sort_constructors_first
class ModelOffers {
  String id;
  String title;
  String startDate;
  String expiryDate;
  int points;
  String imageUrl;
  String description;

  ModelOffers({
    required this.id,
    required this.title,
    required this.startDate,
    required this.expiryDate,
    required this.points,
    required this.imageUrl,
    required this.description,
  });

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      'id': id,
      'title': title,
      'startDate': startDate,
      'expiryDate': expiryDate,
      'points': points,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  factory ModelOffers.fromMap(Map<dynamic, dynamic> map) {
    return ModelOffers(
      id: map['id'] as String,
      title: map['title'] as String,
      startDate: map['startDate'] as String,
      expiryDate: map['expiryDate'] as String,
      points: map['points'] as int,
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
    );
  }
}
