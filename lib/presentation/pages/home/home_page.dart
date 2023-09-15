import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/currency_formater.dart';
import 'package:pos_app/core/injector_container.dart';
import 'package:pos_app/presentation/bloc/order/order_bloc.dart';
import 'package:pos_app/presentation/bloc/product/product_bloc.dart';
import 'package:pos_app/presentation/pages/home/cart.dart';
import 'package:pos_app/presentation/pages/home/product_list.dart';
import 'package:pos_app/presentation/pages/order_detail/order_detail.dart';
import 'package:pos_app/presentation/widget/separator.dart';
import 'package:pos_app/presentation/widget/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productBloc = sl<ProductBloc>();

  @override
  void initState() {
    productBloc.add(GetProductsEvent());
    final state = context.read<OrderBloc>().state;

    if (state.isUpdate && state.updateOrder != null) {
      productBloc.add(UpdateCartEvent(
          products: state.updateOrder!.products,
          orderId: state.updateOrder!.id,
          orderNo: state.updateOrder!.orderNo));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => productBloc,
      child: BlocListener<ProductBloc, ProductState>(
        listenWhen: (p, c) => p.saveStatus != c.saveStatus,
        listener: (context, state) {
          if (state.saveStatus == SaveStatus.saved) {
            Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailPage(
                      products: state.selectedProducts, orderId: state.orderId),
                )).then((value) {
              if (value ?? false) {
                context.read<ProductBloc>().add(ClearCartEvent());
              }
            });

            context.read<OrderBloc>().add(GetOrderSavedEvent());
            return;
          }
          if (state.saveStatus == SaveStatus.errorSave) {
            const snackBar = SnackBar(content: Text('Terjadi Kesalahan'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  widget.scaffoldKey.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu_rounded)),
          ),
          body: const Column(
            children: [
              Separator(),
              SizedBox(height: 16.0),
              Expanded(child: ProductList()),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: BlocBuilder<ProductBloc, ProductState>(
              buildWhen: (p, c) => p.status != c.status,
              builder: (context, state) {
                if (state.selectedProducts.isEmpty) {
                  return const SizedBox();
                }
                final totalPrice = state.selectedProducts.fold(
                  0,
                  (previousValue, element) =>
                      previousValue +
                      ((element.qty ?? 0) * element.price.toInt()),
                );

                final totalQuantity = state.selectedProducts.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + (element.qty ?? 0));

                return Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 5,
                            color: CustomTheme.neutral200,
                            offset: Offset(0, -5))
                      ]),
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          showBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10.0))),
                            builder: (context) {
                              return BlocProvider.value(
                                value: context.read<ProductBloc>(),
                                child: const CartWidget(),
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$totalQuantity Produk',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: CustomTheme.primary),
                              ),
                              Text(
                                totalPrice.toCurrencyFormatted(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      )),
                      InkWell(
                        onTap: () {
                          context.read<ProductBloc>().add(SaveOrderEvent());
                        },
                        child: Container(
                          color: CustomTheme.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16.0),
                          child: Text(
                            'Checkout',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: CustomTheme.neutral),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
