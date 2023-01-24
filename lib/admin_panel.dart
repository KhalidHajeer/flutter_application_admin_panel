import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/coupons/add_new_coupon_page.dart';
import 'package:flutter_application_admin_panel/offers/offer_List_page.dart';
import 'package:flutter_application_admin_panel/products/add_new_product_page.dart';
import 'package:flutter_application_admin_panel/offers/add_new_offer.dart';
import 'package:flutter_application_admin_panel/products/products_List_page.dart';

import 'coupons/coupons_List_page.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddNewProduct(),
                        ));
                  },
                  child: const Text('Add New Product')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductsListPage(),
                        ));
                  },
                  child: const Text('Check or Edit Products')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddNewCoupon(),
                        ));
                  },
                  child: const Text('Add New Coupon')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CouponsListPage(
                            visibilityOthers: true,
                            visibilityAddcoupon: false,
                            user: null,
                          ),
                        ));
                  },
                  child: const Text('Check or Edit Coupons')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddNewOffer(),
                        ));
                  },
                  child: const Text('Add New Offer')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OffersListPage(),
                        ));
                  },
                  child: const Text('Check or Edit Offers')),
            ],
          ),
        ),
      ),
    );
  }
}
