import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/models/model_user.dart';

import '../../../main.dart';
import '../../../utilis.dart';



Future<dynamic> showPointsBottomSheet(BuildContext context, int index,
    TextEditingController controller, List<ModelUser> list) async {
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('How Many Points to add ?'),
                    IconButton(
                        onPressed: (() {
                          controller.text = '${int.parse(controller.text) - 1}';
                          if (int.parse(controller.text) == 0) {
                            Navigator.pop(context);
                          }
                        }),
                        icon: const Icon(Icons.remove)),
/* -------------------------------------------------------------------------- */
/*                              points Text feild                             */
/* -------------------------------------------------------------------------- */
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder()),
                      ),
                    ),
/* ----------------------------------- end ---------------------------------- */
                    IconButton(
                        onPressed: (() {
                          controller.text = '${int.parse(controller.text) + 1}';
                        }),
                        icon: const Icon(Icons.add)),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () async {
                      Utils.showDialogMethod('updating points');
                      await FirebaseDatabase.instance
                          .ref()
                          .child('users')
                          .child(list[index].uid!)
                          .update({
                        'points':
                            int.parse(controller.text) + list[index].points!
                      });
                      
                      navigatorKey.currentState!
                          .popUntil((route) => route.isFirst);
                    },
                    child: const Text('update Points')),
              ],
            ),
          ),
        ),
      );
    },
  );
}
