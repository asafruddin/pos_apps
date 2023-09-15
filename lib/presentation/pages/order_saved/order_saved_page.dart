import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/presentation/bloc/order/order_bloc.dart';
import 'package:pos_app/presentation/pages/main_navigation.dart';
import 'package:pos_app/presentation/pages/order_saved/order_saved_list_widget.dart';
import 'package:pos_app/presentation/widget/separator.dart';
import 'package:pos_app/presentation/widget/theme.dart';

class OrderSavedPage extends StatefulWidget {
  const OrderSavedPage({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<OrderSavedPage> createState() => _OrderSavedPageState();
}

class _OrderSavedPageState extends State<OrderSavedPage> {
  @override
  void initState() {
    super.initState();

    context.read<OrderBloc>().add(GetOrderSavedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              widget.scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu_rounded)),
        title: const Text('Pesanan Tersimpan'),
      ),
      body: Column(
        children: [
          const Separator(),
          Expanded(child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              if (state.orderSaved.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.recycling_rounded,
                        color: CustomTheme.primary,
                        size: 80,
                      ),
                      Text('Belum ada pesanan tersimpan',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: CustomTheme.primary)),
                      OutlinedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainNavigation(),
                                ),
                                (route) => false);
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 10.0))),
                          child: Text(
                            'Buat Pesanan',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: CustomTheme.primary),
                          )),
                      const SizedBox(height: 90.0),
                    ],
                  ),
                );
              }
              return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  itemBuilder: (context, index) {
                    final order = state.orderSaved[index];
                    return OrderSavedListWidget(order: order);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10.0);
                  },
                  itemCount: state.orderSaved.length);
            },
          ))
        ],
      ),
    );
  }
}
