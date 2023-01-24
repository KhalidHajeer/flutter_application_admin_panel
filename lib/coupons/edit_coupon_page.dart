// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_admin_panel/coupons/coupon_card.dart';
import 'package:flutter_application_admin_panel/managers/manager_coupon.dart';
import 'package:flutter_application_admin_panel/models/model_coupon.dart';

import 'package:flutter_application_admin_panel/utilis.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../main.dart';

class EditCouponPage extends StatefulWidget {
  static String routeName = "/edit_coupon_page";
  final ModelCoupon coupon;
  const EditCouponPage({Key? key, required this.coupon}) : super(key: key);

  @override
  _EditCouponPageState createState() => _EditCouponPageState();
}

class _EditCouponPageState extends State<EditCouponPage> {
  String titel = '';
  int price = 0;
  int points = 0;

  @override
  void initState() {
    controllerTitle.text = widget.coupon.couponBookTitle!;
    controllerDescription.text = widget.coupon.couponBookDescription!;
    controllerPoints.text = '${widget.coupon.couponBookPoints!}';
    controllerPrice.text = '${widget.coupon.couponBookPrice!}';
    controllerAvailNum.text = '${widget.coupon.availableCoupons!}';
    controllerProduct.text = widget.coupon.product;

    controllerTitle.addListener(() {
      setState(() => titel = controllerTitle.text);
    });
    super.initState();
  }

  final mangerCoupons = ManagerCoupons();
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerPoints = TextEditingController();
  TextEditingController controllerProduct = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerAvailNum = TextEditingController();

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerPrice.dispose();
    controllerDescription.dispose();
    controllerAvailNum.dispose();

    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  File? imageFile;
  final storage = FirebaseStorage.instance;
  bool showImage = false;
  bool uploaded = false;

  String imageName = '';
  String imageURL = '';
  String id = '';
  static const double height = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Coupon'),
      ),
      body: GestureDetector(
        onTap: (() {
          FocusScope.of(context).unfocus();
        }),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(widget.coupon.key!),
                  // ignore: prefer_const_constructors
                  SizedBox(height: 10),
/* ------------------------------ Coupon Title ------------------------------ */
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: controllerTitle,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      label: const Text('Coupon Book Title'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: height),
/* --------------------------- product description -------------------------- */
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    controller: controllerDescription,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      label: const Text('Coupon Book Description'),
                    ),
                  ),
                  const SizedBox(height: height),
/* ------------------------------ product feild ----------------------------- */
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    controller: controllerProduct,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      label: const Text('what product this coupon have ?'),
                    ),
                  ),
                  const SizedBox(height: height),
/* ---------------------------------- price --------------------------------- */
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        print('setstate : triggered');
                        price = int.parse(controllerPrice.text);
                      });
                    },
                    controller: controllerPrice,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      label: const Text('Coupon Book Price'),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: height),
/* ---------------------------------- points --------------------------------- */
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        print('setstate : triggered');
                        points = int.parse(controllerPoints.text);
                      });
                    },
                    controller: controllerPoints,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      label: const Text('Coupon Book Points'),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: height),

/* --------------------------- How Many Coupons ? --------------------------- */
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    controller: controllerAvailNum,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      label: const Text('How Many Coupons in this Book ?'),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: height),
                  MaterialButton(
                    onPressed: () {
                      pickImage();
                    },
                    color: Colors.blue,
                    minWidth: double.infinity,
                    child: const Text("Pick Image from Gallery",
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold)),
                  ),
                  MaterialButton(
                    color: Colors.amber,
                    minWidth: double.infinity,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        if (imageFile != null) {
                          await upLoadImageAndgetImageURL();
                        }

                        ModelCoupon coupon = ModelCoupon(
                          key: widget.coupon.key,
                          couponBookId: '',
                          couponBookTitle: controllerTitle.text.trim(),
                          couponBookPoints:
                              (num.parse(controllerPoints.text.trim())),
                          couponBookDescription:
                              controllerDescription.text.trim(),
                          product: controllerProduct.text.trim(),
                          couponBookPrice:
                              num.parse(controllerPrice.text.trim()),
                          availableCoupons:
                              int.parse(controllerAvailNum.text.trim()),
                          imageURL: imageURL,
                        );
                        await ManagerCoupons().updateCoupon(coupon);
                      } else {
                        print('not complete info.');
                      }
                    },
                    child: const Text('Update Coupon Info.'),
                  ),
                  const SizedBox(height: 10),
                  imageFile == null
                      ? const SizedBox()
                      : SizedBox(
                          width: double.infinity,
                          child: Image.file(imageFile!, fit: BoxFit.cover),
                        ),
                  CouponCard(
                    model: ModelCoupon(
                        product: titel,
                        couponBookDescription: controllerDescription.text,
                        couponBookTitle: controllerTitle.text,
                        couponBookPrice: controllerPrice.text == ''
                            ? 0
                            : int.parse(controllerPrice.text),
                        availableCoupons: controllerAvailNum.text == ''
                            ? 0
                            : int.parse(controllerAvailNum.text),
                        couponBookPoints: controllerPoints.text == ''
                            ? 0
                            : int.parse(controllerPoints.text)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      imageFile = File(image.path);

      setState(() {
        print('imageName:$imageName');
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future upLoadImageAndgetImageURL() async {
    if (imageFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('images')
          .child(controllerTitle.text.trim());
      try {
        Utils.showDialogMethod(' Please Wait! , up Loading Image');
        await ref.putFile(imageFile!);
        await getImageURL();
      } on FirebaseException catch (e) {
        print(e.message);
      }
      navigatorKey.currentState!.pop();
    } else {
      imageURL = '';
      Utils.showSnackBar('no image file exicts');
    }
  }

  Future getImageURL() async {
    FocusScope.of(context).unfocus();
    var tempName = controllerTitle.text.trim();

    Utils.showDialogMethod('getting image URL');

    imageURL = await FirebaseStorage.instance
        .ref()
        .child('images')
        .child(tempName)
        .getDownloadURL();
  }
}
