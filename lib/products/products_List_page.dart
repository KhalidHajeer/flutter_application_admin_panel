import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/models/model_product.dart';
import 'package:flutter_application_admin_panel/products/edit_product_page.dart';
import 'package:flutter_application_admin_panel/managers/manager_products.dart';
import 'package:provider/provider.dart';

import '../managers/manager_coupon.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({Key? key}) : super(key: key);

  @override
  ProductsListPageState createState() => ProductsListPageState();
}

class ProductsListPageState extends State<ProductsListPage> {
  @override
  void initState() {
    Provider.of<ManagerProducts>(context, listen: false).readAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Products'),
      ),
      body: Consumer<ManagerProducts>(
        builder: (_, manager, __) {
          return manager.allProductList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView.separated(
                    itemCount: manager.allProductList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      var product = manager.allProductList[index];
                      return ProductTileCard(
                          product: product, manager: manager, index: index);
                    },
                  ),
                )
              : const Text('not available coupons');
        },
      ),
    );
  }
}

class ProductTileCard extends StatelessWidget {
  final int index;
  final ManagerProducts manager;
  const ProductTileCard(
      {Key? key,
      required this.product,
      required this.manager,
      required this.index})
      : super(key: key);

  final ModelProduct product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProductPage(
              product: product,
            ),
          ),
        );
      },
      title: Text('Product : ${manager.allProductList[index].description}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Details : ${manager.allProductList[index].details}'),
          Text('points : ${manager.allProductList[index].points}'),
          Text('Price : ${manager.allProductList[index].productPrice} JD'),
        ],
      ),
    );
  }
}
