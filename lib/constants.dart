import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kTealGreenColor = Color.fromARGB(255, 11, 131, 121);
const kNavyBlueColor = Color.fromARGB(255, 10, 65, 88);

const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

const headingStyle = TextStyle(
  fontSize: (28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: (15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular((15)),
    borderSide: const BorderSide(color: kTextColor),
  );
}

// Form Error

// String kNamelNullError = LocaleKeys.please_enter_your_name.tr();
// String kPhoneNumberNullError = LocaleKeys.please_enter_your_phone_number.tr();
// String kAddressNullError = LocaleKeys.please_enter_your_address;
// String kRequired = LocaleKeys.this_field_is_required.tr();
// String kFailed = LocaleKeys.failed_to_modify.tr();

// Database
String dbKey = 'key';
//User
String dbUsers = "users";
String dbFirstName = "first_name";
String dbLastName = "last_name";
String dbPhone = "phone";
String dbPoints = "points";
String dbPlusPoints = "plus_points";
String dbFcmToken = "fcmToken";

//address

String dbAddresses = "addresses";
String dbNickName = "nick_name";
String dbLocation = "location";
String dbLatitude = "latitude";
String dbLongitude = "longitude";
String dbCity = "city";
String dbArea = "area";
String dbStreet = "street";
String dbBuildingNumber = "building_number";
String dbFloor = "floor";
String dbAdditionalDirections = "additional_directions";

// Orders

String dbOrders = 'orders';
String dbCustomerId = "customer_id";
String dbAddressId = "address_id";
String dbNotes = "notes";
String dbTimestamp = "timestamp";
String dbDeliveredAt = "delivered_at";
String dbProducts = "products";
String dbPrice = "price";
String dbStatus = "status";
String dbService = "service";
String dbQuantity = "quantity";
String dbOffer = "offer";

// Coupons
String dbCoupons = "coupons";
String dbCouponId = "coupon_id";
String dbAvailableProducts = "available_products";
String dbProductId = "product_id";
String dbImageUrl = "image_url";
String dbTitle = "title";
String dbLastUsed = "last_used";

// Offers

String dbOffers = 'offers';
String dbBoxFit = 'box_fit';
String dbStartDate = 'start_date';
String dbEndDate = 'end_date';
String dbDescription = 'description';
String dbSubDescription = 'sub_description';
String dbOfferId = 'offer_id';
