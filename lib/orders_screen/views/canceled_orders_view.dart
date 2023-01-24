import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/managers/manager_canceled_orders.dart';
import 'package:provider/provider.dart';

class CanceledOrdersView extends StatelessWidget {
  const CanceledOrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var manager = Provider.of<ManagerCanceledOrders>(context);
    return Scaffold(
      body: manager.canceledOrderList.isEmpty
          ? const Center(
              child: Text(
              'no canceled orders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ))
          : const CanceledListView(),
    );
  }
}

class CanceledListView extends StatefulWidget {
  const CanceledListView({Key? key}) : super(key: key);

  @override
  State<CanceledListView> createState() => _CanceledListViewState();
}

class _CanceledListViewState extends State<CanceledListView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ManagerCanceledOrders>(
      builder: (_, manager, __) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  'You have : ${manager.canceledOrderList.length} Canceled Orders',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  // shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: manager.canceledOrderList.length,
                  itemBuilder: (context, index) {
                    var usersList = manager.usersList;
                    return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                                'Order Id : ${manager.canceledOrderList[index].orderId}'),
                            Text(
                                'Order Status : ${manager.canceledOrderList[index].orderStatus}'),
                            Text(
                                'Order time : ${manager.canceledOrderList[index].timeStamp}'),
                            usersList.isEmpty
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Text('Customer : ${usersList[index].name}'),
                            usersList.isEmpty
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Text(
                                    'Customer : ${usersList[index].phoneNumber}'),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Order Details',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Qty',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            ...manager.canceledOrderList[index].orderList!.map(
                              (e) {
                                for (var i = 0;
                                    i <
                                        manager.canceledOrderList[index]
                                            .orderList!.length;
                                    i++) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(e.singleCartDescription),
                                      Text('${e.singleCartQuantity}'),
                                    ],
                                  );
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                            Text(
                              'Price: ${manager.canceledOrderList[index].totalOrderPrice} JD',
                              textAlign: TextAlign.end,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  confirmOrderPending(context, manager, index);
                                },
                                child: const Text('Mark as Pending')),
                          ],
                        ));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> confirmOrderPending(
      BuildContext context, ManagerCanceledOrders manager, int index) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Mark Order as Pending'),
              content: const Text(
                  'Are you sure you to mark the order to pending list ?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    String? value =
                        manager.canceledOrderList[index].orderPushValue;
                    FirebaseDatabase.instance
                        .ref()
                        .child('orders')
                        .child(value!)
                        .update({'orderStatus': 'pending'});

                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Yes',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ));
  }
}
