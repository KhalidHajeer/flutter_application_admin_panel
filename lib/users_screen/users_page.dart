// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/users_screen/componenets/tab_view/coupons_tab_view.dart';
import 'package:flutter_application_admin_panel/users_screen/componenets/tab_view/user_tab_view.dart';



class CustomerPage extends StatelessWidget {
  const CustomerPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('widget build triggered');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            actions: [
              // IconButton(
              //     onPressed: () => ManagerNotification.showNotification(
              //         id: 0, title: 'titel', body: 'body', payload: ''),
              //     icon: const Icon(Icons.notifications))
            ],
            title: const Text('User Page'),
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.person),
                text: 'Users',
              ),
              Tab(
                icon: Icon(Icons.loyalty),
                text: 'Coupons',
              ),
            ])),
        body: const TabBarView(children: [
          CustomerTabView(),
          CouponsTabView(),
        ]),
      ),
    );
  }
}
