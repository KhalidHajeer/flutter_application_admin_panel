import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_admin_panel/main.dart';

import '../../models/model_user.dart';
import '../../utilis.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final pointsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    pointsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: ListView(
        key: _formKey,
        padding: const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const Text(
                  'Add customer',
                  style: TextStyle(fontSize: 22.0),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'First name',
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  controller: phoneController,
                  maxLength: 13,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.phone_enabled_outlined),
                    labelText: 'phone',
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  controller: pointsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    icon: Icon(Icons.credit_score_outlined),
                    labelText: 'points',
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton.icon(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('cancel')),
                    ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            ModelUser user = ModelUser(
                                name: firstNameController.text.trim(),
                                uid: '',
                                phoneNumber: phoneController.text,
                                points: 0);
                            // await signInAnonymously();
                            await addNewUserToDb(user);
                            Navigator.of(navigatorKey.currentState!.context)
                                .pop();
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('add')),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signInAnonymously() async {
    print('signInAnonymously: triggered');

    try {
      await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          Utils.showSnackBar(
              "Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          Utils.showSnackBar("Unknown error.");
      }
    }
  }

  Future<void> addNewUserToDb(ModelUser user) async {
    await FirebaseDatabase.instance
        .ref()
        .child('users')
        .push()
        .set(user.toMap());
  }
}
