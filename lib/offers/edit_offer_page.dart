// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_admin_panel/models/model_offers.dart';

import 'package:flutter_application_admin_panel/utilis.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../managers/manager_offers.dart';
import 'add_new_offer.dart';

class EditOfferPage extends StatefulWidget {
  static String routeName = "/edit_offer_page";
  final ModelOffers offer;
  const EditOfferPage({Key? key, required this.offer}) : super(key: key);

  @override
  EditOfferPageState createState() => EditOfferPageState();
}

class EditOfferPageState extends State<EditOfferPage> {
  String titel = '';
  int price = 0;
  int points = 0;

  final managerOffers = ManagerOffers();

  @override
  void initState() {
    controllerTitle.text = widget.offer.title;
    controllerDescription.text = widget.offer.description;
    controllerPoints.text = '${widget.offer.points}';
    controllerStartDate.text = widget.offer.startDate;
    controllerEndDate.text = widget.offer.expiryDate;

    controllerTitle.addListener(() {
      setState(() => titel = controllerTitle.text);
    });
    super.initState();
  }

  final controllerTitle = TextEditingController();
  final controllerPoints = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerStartDate = TextEditingController();
  final controllerEndDate = TextEditingController();
  final controllerProduct = TextEditingController();

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerProduct.dispose();
    controllerPoints.dispose();
    controllerDescription.dispose();
    controllerStartDate.dispose();
    controllerEndDate.dispose();
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
        title: const Text('Edit Offers'),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
/* --------------------------- TextFormField Title -------------------------- */
                  TextFormField(
                    controller: controllerTitle,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      label: const Text('offer name'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: height),
/* -------------------------- TextFormField points -------------------------- */
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
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
                      label: const Text('points needed'),
                    ),
                  ),
                  const SizedBox(height: height),
/* --------------------- TextFormField offer description -------------------- */
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
                      label: const Text('offer description'),
                    ),
                  ),
                  const SizedBox(height: height),
/* --------------------- TextButton select date section --------------------- */
                  TextButton.icon(
                    label: const Text('Select date range'),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2025),
                      ).then((DateTimeRange? value) {
                        if (value != null) {
                          DateTimeRange fromRange = DateTimeRange(
                              start: DateTime.now(), end: DateTime.now());
                          fromRange = value;
                          controllerStartDate.text =
                              DateFormat('yyyy-MM-dd').format(fromRange.start);
                          controllerEndDate.text =
                              DateFormat('yyyy-MM-dd').format(fromRange.end);
                          setState(() {});
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.date_range,
                    ),
                  ),
                  Text(
                    'Strat date : ${controllerStartDate.text}',
                    textAlign: TextAlign.start,
                  ),
                  Text('End Date : ${controllerEndDate.text}'),
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
                  const SizedBox(height: height),
                  MaterialButton(
                    minWidth: double.infinity,
                    color: Colors.blue,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );

                        if (imageFile != null) {
                          await upLoadImageAndGetImageURL();
                        }

                        ModelOffers offer = ModelOffers(
                          id: widget.offer.id,
                          title: controllerTitle.text,
                          startDate: controllerStartDate.text,
                          expiryDate: controllerEndDate.text,
                          points: int.parse(controllerPoints.text),
                          imageUrl: imageURL,
                          description: controllerDescription.text,
                        );

                        managerOffers.updateOffer(offer);

                        await managerOffers.updateOffer(offer);
                      } else {
                        print('not complete info.');
                      }
                    },
                    child: const Text('upload and get image url'),
                  ),
                  NewOfferCard(
                      controllerTitle: controllerTitle,
                      controllerPoints: controllerPoints,
                      imageFile: imageFile,
                      controllerDescription: controllerDescription),
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

  Future upLoadImageAndGetImageURL() async {
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
