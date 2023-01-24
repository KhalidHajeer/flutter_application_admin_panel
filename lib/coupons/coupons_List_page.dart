// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_admin_panel/coupons/add_new_coupon_page.dart';
import 'package:flutter_application_admin_panel/coupons/edit_coupon_page.dart';
import 'package:flutter_application_admin_panel/main.dart';
import 'package:flutter_application_admin_panel/managers/manager_coupon.dart';
import 'package:flutter_application_admin_panel/models/model_coupon.dart';
import 'package:flutter_application_admin_panel/models/model_user.dart';

class CouponsListPage extends StatefulWidget {
  final bool visibilityAddcoupon;
  final bool visibilityOthers;
  final ModelUser? user;

  const CouponsListPage({
    Key? key,
    required this.visibilityAddcoupon,
    required this.visibilityOthers,
    this.user,
  }) : super(key: key);

  @override
  State<CouponsListPage> createState() => _CouponsListPageState();
}

class _CouponsListPageState extends State<CouponsListPage> {
  @override
  void initState() {
    Provider.of<ManagerCoupons>(context, listen: false).readProductCoupons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check or Edit Coupons'),
      ),
      body: Consumer<ManagerCoupons>(
        builder: (_, manager, __) {
          return manager.couponsProductList.isNotEmpty
              ? ListView.separated(
                  itemCount: manager.couponsProductList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    var model = manager.couponsProductList[index];
                    return _CouponListTileCard(
                      model: model,
                      index: index,
                      manager: manager,
                      visibilityAddcoupon: widget.visibilityAddcoupon,
                      visibilityOthers: widget.visibilityOthers,
                      user: widget.user,
                    );
                  },
                )
              : const Text('not available coupons');
        },
      ),
    );
  }
}

class _CouponListTileCard extends StatelessWidget {
  const _CouponListTileCard({
    Key? key,
    required this.model,
    required this.manager,
    required this.index,
    required this.visibilityAddcoupon,
    required this.visibilityOthers,
    required this.user,
  }) : super(key: key);

  final ModelCoupon model;
  final ManagerCoupons manager;
  final int index;
  final bool visibilityAddcoupon;
  final bool visibilityOthers;
  final ModelUser? user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListTile(
        title: Text('${manager.couponsProductList[index].couponBookTitle}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Coupon Details : ${manager.couponsProductList[index].couponBookDescription}'),
            Text(
                'Number of Coupons : ${manager.couponsProductList[index].availableCoupons}'),
            Text(
                'Price : ${manager.couponsProductList[index].couponBookPrice}'),
            Text(
                'points : ${manager.couponsProductList[index].couponBookPoints}'),
            Text('product : ${manager.couponsProductList[index].product}'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /* ---------------------------------------------------------- */
                /*                        Delete Coupon                       */
                /* ---------------------------------------------------------- */
                Visibility(
                  visible: visibilityOthers,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 20),
                        backgroundColor: Colors.red,
                      ),
                      onPressed: (() {}),
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete')),
                ),
                /* --------------------------- end -------------------------- */

                const SizedBox(width: 50),
                /* ---------------------------------------------------------- */
                /*                        Edit Coupons                        */
                /* ---------------------------------------------------------- */
                Visibility(
                  visible: visibilityOthers,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 20),
                      ),
                      onPressed: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditCouponPage(
                                      coupon: model,
                                    )));
                      }),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit')),
                ),
                /* --------------------------- end -------------------------- */
                const SizedBox(width: 50),
                /* ---------------------------------------------------------- */
                /*                         Add Coupons                        */
                /* ---------------------------------------------------------- */
                Visibility(
                    visible: visibilityAddcoupon,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        manager.addCouponToUser(
                            coupon: manager.couponsProductList[index],
                            user: user!);
                      },
                      label: const Text('add coupon'),
                    )),
                /* --------------------------- end -------------------------- */
              ],
            )
          ],
        ),
      ),
    );
  }
}
