// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_admin_panel/managers/manager_coupon.dart';

class CouponsTabView extends StatefulWidget {
  const CouponsTabView({Key? key}) : super(key: key);
  @override
  State<CouponsTabView> createState() => _CouponsTabViewState();
}

class _CouponsTabViewState extends State<CouponsTabView> {
  @override
  void initState() {
    ManagerCoupons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ListOfCouponsWidget(),
    );
  }
}

class ListOfCouponsWidget extends StatelessWidget {
  const ListOfCouponsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ManagerCoupons>(
      builder: (context, manager, child) {
        return manager.usersCouponList.isEmpty
            ? const Center(child: Text('No Electronic Coupons Available'))
            : Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Provider.of<ManagerCoupons>(context, listen: false)
                              .getAllUserCoupons();
                        },
                        child: const Text('refresh List')),
                    const SizedBox(height: 10),
                    Text('Available Books : ${manager.usersCouponList.length}'),
                    Text(
                        'Total Coupons in Books : ${manager.usersCouponList.fold(0, (previousValue, element) => element.availableCoupons! + previousValue)}'),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10);
                        },
                        shrinkWrap: true,
                        itemCount: manager.usersCouponList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListOfCouponCard(
                            manager: manager,
                            index: index,
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

class ListOfCouponCard extends StatelessWidget {
  final ManagerCoupons manager;
  final int index;

  const ListOfCouponCard({
    Key? key,
    required this.manager,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.zero,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Title : ${manager.usersCouponList[index].couponBookTitle}'),
            Text(
                'No. of Coupons : ${manager.usersCouponList[index].availableCoupons}'),
          ],
        ),
        subtitle: Text('Id : ${manager.usersCouponList[index].couponBookId}'),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_downward),
          onPressed: (() {}),
        ));
  }
}
