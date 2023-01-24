// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter_application_admin_panel/managers/manager_offers.dart';
import 'package:flutter_application_admin_panel/models/model_offers.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_admin_panel/managers/manager_products.dart';
import 'package:flutter_application_admin_panel/utilis.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../main.dart';

class AddNewOffer extends StatefulWidget {
  static String routeName = "/AddNewProduct";
  const AddNewOffer({Key? key}) : super(key: key);

  @override
  AddNewOfferState createState() => AddNewOfferState();
}

class AddNewOfferState extends State<AddNewOffer> {
  final managerOffers = ManagerOffers();

  final controllerTitle = TextEditingController();
  final controllerPoints = TextEditingController();
  final controllerDescription = TextEditingController();

  final controllerStartDate = TextEditingController();
  final controllerEndDate = TextEditingController();

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerPoints.dispose();
    controllerDescription.dispose();
    controllerStartDate.dispose();
    controllerEndDate.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  File? imageFile;

  String imageName = '';
  String imageURL = '';
  static const double height = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Offer'),
      ),
      body: SingleChildScrollView(
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
                          color: Colors.white70, fontWeight: FontWeight.bold)),
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

                      String offerPushKey = managerOffers.getNewOfferPushKey();

                      ModelOffers offer = ModelOffers(
                        id: offerPushKey,
                        title: controllerTitle.text,
                        startDate: controllerStartDate.text,
                        expiryDate: controllerEndDate.text,
                        points: int.parse(controllerPoints.text),
                        imageUrl: imageURL,
                        description: controllerDescription.text,
                      );

                      await managerOffers.creatNewOffer(offer, offerPushKey);
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

class NewOfferCard extends StatelessWidget {
  const NewOfferCard({
    Key? key,
    required this.controllerTitle,
    required this.controllerPoints,
    required this.imageFile,
    required this.controllerDescription,
  }) : super(key: key);

  final TextEditingController controllerTitle;
  final TextEditingController controllerPoints;
  final File? imageFile;
  final TextEditingController controllerDescription;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.arrow_drop_down_circle),
            title: Text(controllerTitle.text),
            subtitle: Text(
              'Points Needed : ${controllerPoints.text}',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          imageFile == null
              ? const SizedBox()
              : SizedBox(
                  width: double.infinity,
                  child: Image.file(imageFile!, fit: BoxFit.cover),
                ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              controllerDescription.text,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: (0)),
                onPressed: () {
                  // Perform some action
                },
                child: const Text('Use Offer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
