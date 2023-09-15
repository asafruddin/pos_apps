import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/core/currency_formater.dart';
import 'package:pos_app/domain/entity/order_entity.dart';
import 'package:pos_app/presentation/bloc/order/order_bloc.dart';
import 'package:pos_app/presentation/pages/order_detail/order_detail.dart';
import 'package:pos_app/presentation/widget/theme.dart';

class OrderSavedListWidget extends StatelessWidget {
  const OrderSavedListWidget({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailPage(
                  products: order.products,
                  orderId: order.id,
                  orderNo: order.orderNo),
            ));
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: CustomTheme.neutral,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 8,
                  offset: Offset(0, 1),
                  color: CustomTheme.neutral200)
            ]),
        child: Column(
          children: [
            OrderTransaction(order: order),
            const SizedBox(height: 20.0),
            OrderTimeAndPrice(
                dateTime: order.orderDate, totalPrice: order.totalPrice),
            const SizedBox(height: 16.0),
            const Divider(
              height: 0,
              color: CustomTheme.neutral200,
              thickness: 1,
            ),
            TextButton(
                onPressed: () {
                  context
                      .read<OrderBloc>()
                      .add(DeleteOrderSavedEvent(orderId: order.id));
                },
                child: Text(
                  'Hapus Pesanan',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.red, fontWeight: FontWeight.w600),
                ))
          ],
        ),
      ),
    );
  }
}

class OrderTransaction extends StatelessWidget {
  const OrderTransaction({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/svg/document.svg'),
          const SizedBox(width: 8.0),
          Text(order.orderNo, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: 8.0),
          const VerticalDivider(thickness: 1, color: CustomTheme.neutral200),
          const SizedBox(width: 8.0),
          Expanded(
              child: Text('${order.products.length}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600)))
        ],
      ),
    );
  }
}

class OrderTimeAndPrice extends StatelessWidget {
  const OrderTimeAndPrice(
      {super.key, required this.dateTime, required this.totalPrice});

  final DateTime dateTime;
  final int totalPrice;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.0,
      child: Row(
        children: [
          Text(DateFormat('EEEE, dd MMM yy').format(dateTime),
              style: Theme.of(context).textTheme.bodyMedium),
          const VerticalDivider(color: CustomTheme.neutral200, thickness: 1),
          Text(DateFormat('HH:mm').format(dateTime),
              style: Theme.of(context).textTheme.bodyMedium),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(totalPrice.toCurrencyFormatted(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600)),
            ),
          )
        ],
      ),
    );
  }
}
