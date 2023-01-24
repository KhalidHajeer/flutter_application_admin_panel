import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/managers/manager_offers.dart';
import 'package:flutter_application_admin_panel/managers/manager_users.dart';
import 'package:flutter_application_admin_panel/managers/manager_delivered_orders.dart';
import 'package:flutter_application_admin_panel/managers/manager_canceled_orders.dart';
import 'package:flutter_application_admin_panel/orders_screen/orders_page.dart';
import 'package:flutter_application_admin_panel/managers/manager_products.dart';
import 'package:flutter_application_admin_panel/admin_panel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'managers/manager_coupon.dart';
import 'users_screen/users_page.dart';
import 'firebase_options.dart';
import 'managers/manager_pending_orders.dart';
import 'utilis.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp((MultiProvider(providers: [
    ChangeNotifierProvider<ManagerProducts>(
      create: (context) => ManagerProducts(),
    ),
    ChangeNotifierProvider<ManagerCoupons>(
      create: (context) => ManagerCoupons(),
    ),
    ChangeNotifierProvider<ManagerOffers>(
      create: (context) => ManagerOffers(),
    ),
    ChangeNotifierProvider<ManagerPendingOrder>(
      create: (context) => ManagerPendingOrder(),
    ),
    ChangeNotifierProvider<ManagerCanceledOrders>(
      create: (context) => ManagerCanceledOrders(),
    ),
    ChangeNotifierProvider<ManagerDelieveredOrder>(
      create: (context) => ManagerDelieveredOrder(),
    ),
    ChangeNotifierProvider<ManagerUsers>(
      create: (context) => ManagerUsers(context),
    ),
  ], child: const MyApp())));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

      

  @override
  Widget build(BuildContext context) {

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    return MaterialApp(
      scaffoldMessengerKey: Utils.massangerKey,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _selectedIndex = 0;

  List pages = [
    const CustomerPage(),
    const OrdersPage(),
    const AdminPanel(),
  ];
  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Customer'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.admin_panel_settings), label: 'Orders,'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.admin_panel_settings), label: 'Admin,'),
            ]),
        body: pages[_selectedIndex]);
  }
}
