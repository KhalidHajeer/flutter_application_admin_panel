import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/managers/manager_delivered_orders.dart';
import 'package:provider/provider.dart';

class DeliveredOrdersView extends StatefulWidget {
  const DeliveredOrdersView({Key? key}) : super(key: key);

  @override
  State<DeliveredOrdersView> createState() => _DeliveredOrdersViewState();
}

class _DeliveredOrdersViewState extends State<DeliveredOrdersView> {
  @override
  void initState() {
    ManagerDelieveredOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var manager = Provider.of<ManagerDelieveredOrder>(context);

    return Scaffold(
      body: manager.deliveredOrderList.isEmpty
          ? const Center(
              child: Text(
              'no delivered orders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ))
          : const DeliveredListView(),
    );
  }
}

class DeliveredListView extends StatelessWidget {
  const DeliveredListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ManagerDelieveredOrder>(
      builder: (_, manager, __) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  'You have : ${manager.deliveredOrderList.length} Delivered Order',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left),
              const SizedBox(height: 10),
              DeliveredOrderWidget(
                manager: manager,
              ),
            ],
          ),
        );
      },
    );
  }
}

class DeliveredOrderWidget extends StatelessWidget {
  final ManagerDelieveredOrder manager;
  const DeliveredOrderWidget({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        // shrinkWrap: true,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: manager.deliveredOrderList.length,
        itemBuilder: (context, index) {
          var usersList = manager.usersList;
          return Container(
              padding: const EdgeInsets.all(10),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                      'Order Id : ${manager.deliveredOrderList[index].orderId}'),
                  Text(
                      'Order Status : ${manager.deliveredOrderList[index].orderStatus}'),
                  Text(
                      'Order time : ${manager.deliveredOrderList[index].timeStamp}'),
                  usersList.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Text('Customer : ${usersList[index].name}'),
                  usersList.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Text('Customer : ${usersList[index].phoneNumber}'),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Order Details',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Qty',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ...manager.deliveredOrderList[index].orderList!.map(
                    (e) {
                      for (var i = 0;
                          i <
                              manager
                                  .deliveredOrderList[index].orderList!.length;
                          i++) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    'Price: ${manager.deliveredOrderList[index].totalOrderPrice} JD',
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        manager.confirmOrderPending(context, index);
                      },
                      child: const Text('Mark as Pending')),
                ],
              ));
        },
      ),
    );
  }
}
