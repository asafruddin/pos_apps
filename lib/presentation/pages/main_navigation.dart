import 'package:flutter/material.dart';
import 'package:pos_app/presentation/pages/home/home_page.dart';
import 'package:pos_app/presentation/pages/order_saved/order_saved_page.dart';
import 'package:pos_app/presentation/widget/drawer.dart';

const kHomePage = 'home_page';
const kOrderSavedPage = 'order_saved_page';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final selectedPage = ValueNotifier<String>(kHomePage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: ValueListenableBuilder<String>(
          valueListenable: selectedPage,
          builder: (context, value, child) {
            return MainDrawer(
              selectedPage: value,
              onCashierTap: () {
                selectedPage.value = kHomePage;
                Navigator.pop(context);
              },
              onOrderSavedTap: () {
                selectedPage.value = kOrderSavedPage;
                Navigator.pop(context);
              },
            );
          }),
      body: ValueListenableBuilder(
        valueListenable: selectedPage,
        builder: (context, value, child) {
          switch (value) {
            case kHomePage:
              return HomePage(scaffoldKey: _key);
            case kOrderSavedPage:
              return OrderSavedPage(scaffoldKey: _key);
            default:
              return HomePage(scaffoldKey: _key);
          }
        },
      ),
    );
  }
}
