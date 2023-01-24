import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/main.dart';
import 'package:flutter_application_admin_panel/models/model_user.dart';
import 'package:flutter_application_admin_panel/utilis.dart';



showNameBottomSheet(
    BuildContext context, int index, List<ModelUser> list) async {
  String newName = '';

  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .25,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                const Text('Update the Name of Customer'),

/* -------------------------------------------------------------------------- */
/*                              name Text feild                               */
/* -------------------------------------------------------------------------- */
                TextFormField(
                  initialValue: '${list[index].name}',
                  onChanged: (value) {
                    newName = value;
                  },
                  keyboardType: TextInputType.name,
                  decoration:
                      const InputDecoration(border: UnderlineInputBorder()),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (newName == '') {
                        Utils.showSnackBar('No Name Available');
                      } else {
                        Utils.showDialogMethod('updating name');

                        await FirebaseDatabase.instance
                            .ref()
                            .child('users')
                            .child(list[index].uid!)
                            .update({'name': newName});

                        navigatorKey.currentState!
                            .popUntil((route) => route.isFirst);
                      }
                    },
                    child: const Text('update Name')),
              ],
            ),
          ),
        ),
      );
    },
  );
}
