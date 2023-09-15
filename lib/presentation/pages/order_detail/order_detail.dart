import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/currency_formater.dart';
import 'package:pos_app/domain/entity/product_list_entity.dart';
import 'package:pos_app/presentation/bloc/order/order_bloc.dart';
import 'package:pos_app/presentation/pages/complete/complete_page.dart';
import 'package:pos_app/presentation/pages/main_navigation.dart';
import 'package:pos_app/presentation/pages/order_detail/order_summary.dart';
import 'package:pos_app/presentation/pages/order_detail/order_type_widget.dart';
import 'package:pos_app/presentation/widget/separator.dart';
import 'package:pos_app/presentation/widget/theme.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage(
      {super.key, required this.products, required this.orderId, this.orderNo});

  final List<ProductEntity> products;
  final int orderId;
  final String? orderNo;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final orderType = ValueNotifier(1);

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listenWhen: (p, c) => p.deleteStatus != c.deleteStatus,
      listener: (context, state) {
        if (state.deleteStatus == DeleteStatus.deleted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CompletePage(),
              ));
          return;
        }
        if (state.deleteStatus == DeleteStatus.errorDelete) {
          const snackBar = SnackBar(content: Text('Terjadi Kesalahan'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: widget.orderNo == null,
          title: const Text('Detail Pesanan'),
          actions: [
            if (widget.orderNo != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(widget.orderNo!),
                ),
              )
          ],
        ),
        bottomNavigationBar: SafeArea(
            child: Container(
          decoration: const BoxDecoration(
            color: CustomTheme.neutral,
            boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  offset: Offset(0, -5),
                  color: CustomTheme.neutral200)
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: ElevatedButton(
              onPressed: () {
                context
                    .read<OrderBloc>()
                    .add(DeleteOrderSavedEvent(orderId: widget.orderId));
              },
              child: const Text('Bayar')),
        )),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Separator(),
              ...widget.products.map((e) {
                final totalPrice = (e.qty ?? 0) * e.price;
                return OrderListWidget(
                    title: Text(e.name),
                    subtitle: Text(e.price.toCurrencyFormatted()),
                    trailing: Text(e.qty.toString()),
                    totalPrice: Text(totalPrice.toCurrencyFormatted()));
              }).toList(),
              OrderListWidget(
                title: const Text('Pesanan sudah benar?'),
                subtitle: Text('Ubah pesananmu',
                    style: Theme.of(context).textTheme.labelMedium),
                trailing: InkWell(
                  onTap: () {
                    context
                        .read<OrderBloc>()
                        .add(UpdateActionEvent(orderId: widget.orderId));
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainNavigation(),
                        ),
                        (route) => false);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: CustomTheme.primary)),
                    child: Text(
                      'Ubah',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: CustomTheme.primary,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Simpan Pesanan')),
              const Separator(),
              OrderTypeWidget(orderType: orderType),
              const Separator(),
              OrderSummaryWidget(products: widget.products),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderListWidget extends StatelessWidget {
  const OrderListWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.trailing,
      this.totalPrice});

  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final Widget? totalPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: CustomTheme.neutral200))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w600),
                child: title),
            const SizedBox(height: 10.0),
            DefaultTextStyle(
                style: Theme.of(context).textTheme.labelMedium!,
                child: subtitle)
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w600),
                child: trailing),
            if (totalPrice != null) const SizedBox(height: 10.0),
            DefaultTextStyle(
                style: Theme.of(context).textTheme.labelMedium!,
                child: totalPrice ?? const SizedBox())
          ],
        ),
      ]),
    );
  }
}
