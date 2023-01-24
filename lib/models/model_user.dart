// ignore_for_file: public_member_api_docs, sort_constructors_first

class ModelUser {
  String? uid;
  String? name;
  String? secondName;
  String? phoneNumber;
  int? points = 0;

  ModelUser({
    this.uid,
    this.name,
    this.phoneNumber,
    this.points,
  });

  Map<dynamic, dynamic> toMap() {
    return <dynamic, dynamic>{
      'uid': uid,
      'name': name,
      'phoneNumber': phoneNumber,
      'points': points,
    };
  }

  factory ModelUser.fromMap(Map<dynamic, dynamic> map) {
    return ModelUser(
      uid: map['uid'] != null ? map['uid'] as String : '',
      name: map['name'] != null ? map['name'] as String : '',
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : '',
      points: map['points'] != null ? map['points'] as int : 0,
    );
  }
}
