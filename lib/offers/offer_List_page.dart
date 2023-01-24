import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/managers/manager_offers.dart';
import 'package:flutter_application_admin_panel/models/model_offers.dart';
import 'package:flutter_application_admin_panel/offers/edit_offer_page.dart';
import 'package:provider/provider.dart';

class OffersListPage extends StatefulWidget {
  const OffersListPage({Key? key}) : super(key: key);

  @override
  State<OffersListPage> createState() => _OffersListPageState();
}

class _OffersListPageState extends State<OffersListPage> {
  @override
  void initState() {
    ManagerOffers();
    Provider.of<ManagerOffers>(context, listen: false).readOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check or Edit Offers'),
      ),
      body: Consumer<ManagerOffers>(
        builder: (_, manager, __) {
          return manager.offerList.isNotEmpty
              ? ListView.separated(
                  itemCount: manager.offerList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    var model = manager.offerList[index];
                    return OfferListTileCard(
                      model: model,
                      index: index,
                      manager: manager,
                    );
                  },
                )
              : const Text('not available offers');
        },
      ),
    );
  }
}

class OfferListTileCard extends StatelessWidget {
  const OfferListTileCard({
    Key? key,
    required this.model,
    required this.manager,
    required this.index,
  }) : super(key: key);

  final ModelOffers model;
  final ManagerOffers manager;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListTile(
        title: Text(manager.offerList[index].title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('offer description : ${manager.offerList[index].description}'),
            Text('Number of points : ${manager.offerList[index].points}'),
            Text('Start Date : ${manager.offerList[index].startDate}'),
            Text('Expiry Date : ${manager.offerList[index].expiryDate}'),
            Text('Id : ${manager.offerList[index].id}'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 20),
                      backgroundColor: Colors.red,
                    ),
                    onPressed: (() {}),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete')),
                const SizedBox(
                  width: 50,
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 20),
                    ),
                    onPressed: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditOfferPage(
                            offer: model,
                          ),
                        ),
                      );
                    }),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
