import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_app/presentation/pages/main_navigation.dart';
import 'package:pos_app/presentation/widget/theme.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer(
      {super.key,
      required this.onCashierTap,
      required this.onOrderSavedTap,
      required this.selectedPage});

  final Function() onCashierTap;
  final Function() onOrderSavedTap;
  final String selectedPage;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              color: CustomTheme.neutral,
              padding: const EdgeInsets.all(24.0),
              child: InkWell(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.person_2,
                      color: CustomTheme.primary,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      'TokoKU',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Expanded(child: SizedBox(width: 0.0)),
                    const Icon(Icons.chevron_right_rounded)
                  ],
                ),
              ),
            ),
            const Divider(
              height: 0,
              color: CustomTheme.neutral200,
            ),
            DrawerMenuTile(
              onTap: onCashierTap,
              leading: SvgPicture.asset(
                'assets/svg/cashier.svg',
                height: 20.0,
                width: 20.0,
              ),
              backgroundColor: selectedPage == kHomePage
                  ? CustomTheme.primary.withOpacity(0.2)
                  : null,
              title: Text(
                'Kasir',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight:
                        selectedPage == kHomePage ? FontWeight.w600 : null),
              ),
            ),
            DrawerMenuTile(
              onTap: onOrderSavedTap,
              leading: const Icon(
                Icons.check_box_rounded,
                color: CustomTheme.primary,
                size: 20.0,
              ),
              backgroundColor: selectedPage == kOrderSavedPage
                  ? CustomTheme.primary.withOpacity(0.2)
                  : null,
              title: Text(
                'Pesanan Tersimpan',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: selectedPage == kOrderSavedPage
                        ? FontWeight.w600
                        : null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerMenuTile extends StatelessWidget {
  const DrawerMenuTile(
      {super.key,
      required this.leading,
      required this.title,
      this.backgroundColor,
      this.onTap});

  final Widget leading;
  final Widget title;
  final Color? backgroundColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          children: [leading, const SizedBox(width: 10.0), title],
        ),
      ),
    );
  }
}
