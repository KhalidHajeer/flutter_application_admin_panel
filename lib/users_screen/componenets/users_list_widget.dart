import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/coupons/coupons_List_page.dart';
import 'package:flutter_application_admin_panel/users_screen/componenets/bottom_sheets/bottom_sheet_name.dart';
import 'package:flutter_application_admin_panel/users_screen/componenets/bottom_sheets/bottom_sheet_points.dart';

import '../../models/model_user.dart';

class UsersListWidget extends StatefulWidget {
  final List<ModelUser> list;
  const UsersListWidget({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  State<UsersListWidget> createState() => _UsersListWidgetState();
}

class _UsersListWidgetState extends State<UsersListWidget> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controllerPoints =
        TextEditingController(text: '${1}');

    return ListView.builder(
      itemCount: widget.list.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: ListTile(
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                    child: TextButton(
                        style: TextButton.styleFrom(
                            minimumSize: const Size(
                                double.infinity, double.minPositive)),
                        onPressed: () {
                          showPointsBottomSheet(
                              context, index, controllerPoints, widget.list);
                        },
                        child: const Text('Edit Points'))),
                PopupMenuItem(
                    child: TextButton(
                        style: TextButton.styleFrom(
                            minimumSize: const Size(
                                double.infinity, double.minPositive)),
                        onPressed: () {
                          showNameBottomSheet(context, index, widget.list);
                        },
                        child: const Text('Edit Name'))),
                PopupMenuItem(
                    child: TextButton(
                        style: TextButton.styleFrom(
                            minimumSize: const Size(
                                double.infinity, double.minPositive)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CouponsListPage(
                                user: widget.list[index],
                                visibilityOthers: false,
                                visibilityAddcoupon: true,
                              ),
                            ),
                          );
                        },
                        child: const Text('Add Coupon'))),
              ],
            ),
            key: ValueKey(widget.list[index].uid),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name : ${widget.list[index].name}'),
                Text('Phone : ${widget.list[index].phoneNumber}'),
                Text('Points : ${widget.list[index].points}'),
              ],
            ),
            subtitle: Text(
              'User ID : ${widget.list[index].uid}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        );
      },
    );
  }
}
