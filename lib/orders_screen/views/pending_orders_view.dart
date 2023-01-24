import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../managers/manager_pending_orders.dart';

class PendingOrdersView extends StatefulWidget {
  const PendingOrdersView({super.key});

  @override
  State<PendingOrdersView> createState() => _PendingOrdersViewState();
}

class _PendingOrdersViewState extends State<PendingOrdersView> {
  @override
  void initState() {
    ManagerPendingOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var manager = Provider.of<ManagerPendingOrder>(context);

    return Scaffold(
      
      body: SizedBox(
        width: double.infinity,
        child: manager.pendingOrderList.isEmpty
            ? const Center(
                child: Text(
                  'No Pending Orders',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            : const PendingListView(),
      ),
    );
  }
}

class PendingListView extends StatelessWidget {
  const PendingListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ManagerPendingOrder>(
      builder: (_, manager, __) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  'You have : ${manager.pendingOrderList.length} Pending Orders',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  // shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: manager.pendingOrderList.length,
                  itemBuilder: (context, index) {
                    var usersList = manager.usersList;
                    return GestureDetector(
                      onDoubleTap: () {
                       
                      },
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                  'Order Id : ${manager.pendingOrderList[index].orderId}'),
                              Text(
                                  'Order Status : ${manager.pendingOrderList[index].orderStatus}'),
                              Text(
                                  'Order time : ${manager.pendingOrderList[index].timeStamp}'),
                              usersList.isEmpty
                                  ? const Center(
                                      child: Text('uaerList is empty'))
                                  : Text('Customer : ${usersList[index].name}'),
                              usersList.isEmpty
                                  ? const Center(
                                      child: Text('userList is empty'))
                                  : Text(
                                      'Customer : ${usersList[index].phoneNumber}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              ...manager.pendingOrderList[index].orderList!.map(
                                (e) {
                                  for (var i = 0;
                                      i <
                                          manager.pendingOrderList[index]
                                              .orderList!.length;
                                      i++) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              e.singleCartDescription,
                                              maxLines: 2,
                                            )),
                                        if (e.useCoupon)
                                          const Expanded(
                                              flex: 2,
                                              child: Text('useCoupon : yes'))
                                        else if (e.useOffer)
                                          const Text('Offer : Yes'),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              '${e.singleCartQuantity}',
                                              textAlign: TextAlign.right,
                                            )),
                                      ],
                                    );
                                  }
                                  return const CircularProgressIndicator();
                                },
                              ),
                              Text(
                                'Price: ${manager.pendingOrderList[index].totalOrderPrice} JD',
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    manager.confirmOrderDelivered(
                                        context, index);
                                  },
                                  child: const Text('Mark as Delivered')),
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                  ),
                                  onPressed: () {
                                    manager.confirmCancelOrder(context, index);
                                  },
                                  child: const Text('cancel order')),
                            ],
                          )),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
