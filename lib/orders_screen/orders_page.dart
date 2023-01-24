import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/managers/notification_service.dart';
import 'package:flutter_application_admin_panel/orders_screen/views/canceled_orders_view.dart';
import 'package:flutter_application_admin_panel/orders_screen/views/delivered_orders_view.dart';
import 'package:flutter_application_admin_panel/orders_screen/views/pending_orders_view.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  NotificationManager notificationManager = NotificationManager();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationManager.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await notificationManager.showNotification();
            },
            child: const Icon(Icons.notifications),
          ),
          appBar: AppBar(
              title: const Text('Order Managment Page'),
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.pending), text: 'Pending'),
                  Tab(
                    icon: Icon(Icons.delivery_dining_rounded),
                    text: 'Delievered',
                  ),
                  Tab(
                    icon: Icon(Icons.cancel),
                    text: 'Canceled',
                  ),
                ],
              )),
          body: const TabBarView(children: [
            PendingOrdersView(),
            DeliveredOrdersView(),
            CanceledOrdersView(),
          ])),
    );
  }
}
