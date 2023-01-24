import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_admin_panel/models/model_product.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import '../utilis.dart';
import '../managers/manager_products.dart';

class EditProductPage extends StatefulWidget {
  final ModelProduct product;

  const EditProductPage({Key? key, required this.product}) : super(key: key);

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final controllerName = TextEditingController();
  final controllerPrice = TextEditingController();
  final controllerPoints = TextEditingController();
  final controllerDescription = TextEditingController();

  final mangerProduct = ManagerProducts();
  final formKey = GlobalKey<FormState>();
  final storage = FirebaseStorage.instance;
  File? imageFile;
  String imageName = '';
  String imageURL = '';
  static const double height = 10;

  @override
  void initState() {
    controllerName.text = widget.product.description!;
    controllerPrice.text = '${widget.product.productPrice!}';
    controllerPoints.text = '${widget.product.points!}';
    controllerDescription.text = widget.product.details!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('update Product'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(widget.product.key!),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: controllerName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    label: const Text('product name'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: height),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  controller: controllerPrice,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    label: const Text('price'),
                  ),
                ),
                const SizedBox(height: height),
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
                    label: const Text('product description'),
                  ),
                ),
                const SizedBox(height: height),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  controller: controllerPoints,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    label: const Text('points'),
                  ),
                ),
                const SizedBox(height: height),
                MaterialButton(
                  onPressed: () {
                    pickImage();
                  },
                  color: Colors.blue,
                  minWidth: double.infinity,
                  child: const Text("1) Pick Image from Gallery",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                ),
                MaterialButton(
                    minWidth: double.infinity,
                    color: Colors.blue,
                    child: const Text("upLoad Image to cloud storage",
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      upLoadImage();
                    }),
                MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      if (imageFile != null) {
                        await upLoadImage();
                        await getImageURL();
                      }

                      ModelProduct product = ModelProduct(
                        key: widget.product.key,
                        points: int.parse(controllerPoints.text.trim()),
                        description: controllerName.text.trim(),
                        details: controllerDescription.text.trim(),
                        imageURL: imageURL,
                        productPrice: num.parse(controllerPrice.text.trim()),
                      );

                      await mangerProduct.updateProduct(product);
                    } else {
                      print('not complete info.');
                    }
                  },
                  child: const Text('upload and get image url'),
                ),
                imageFile == null
                    ? const SizedBox()
                    : SizedBox(
                        width: double.infinity,
                        child: Image.file(imageFile!, fit: BoxFit.cover),
                      ),
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

  Future upLoadImage() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child(controllerName.text.trim());

    try {
      Utils.showDialogMethod(' Please Wait! , up Loading Image');
      await ref.putFile(imageFile!);
    } on FirebaseException catch (e) {
      print(e.message);
    }
    navigatorKey.currentState!.pop();
  }

  Future getImageURL() async {
    FocusScope.of(context).unfocus();
    var tempName = controllerName.text.trim();

    Utils.showDialogMethod('getting image URL');

    imageURL = await FirebaseStorage.instance
        .ref()
        .child('images')
        .child(tempName)
        .getDownloadURL();

    navigatorKey.currentState!.pop();
  }
}
