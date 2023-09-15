import 'package:flutter/material.dart';
import 'package:pos_app/core/currency_formater.dart';
import 'package:pos_app/domain/entity/product_list_entity.dart';
import 'package:pos_app/presentation/widget/theme.dart';

class OrderSummaryWidget extends StatelessWidget {
  const OrderSummaryWidget({super.key, required this.products});

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    final totalPrice =
        products.fold(0, (prev, e) => prev + ((e.qty ?? 0) * e.price.toInt()));
    const diskon = 0;
    final totalPayment = totalPrice - diskon;

    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          border: Border.all(
            color: CustomTheme.neutral200,
          ),
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Pembayaran',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16.0),
          RowContent(
              title: const Text('Harga'),
              content: Text(totalPrice.toCurrencyFormatted())),
          const SizedBox(height: 10.0),
          RowContent(
              title: const Text('Diskon'),
              content: Text(diskon.toCurrencyFormatted())),
          const SizedBox(height: 16.0),
          const Divider(height: 0, color: CustomTheme.neutral200, thickness: 1),
          const SizedBox(height: 16.0),
          RowContent(
              title: Text(
                'Total Pembayaran',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              content: Text(totalPayment.toCurrencyFormatted(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600)))
        ],
      ),
    );
  }
}

class RowContent extends StatelessWidget {
  const RowContent({
    super.key,
    required this.title,
    required this.content,
  });
  final Widget title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium!, child: title),
        DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium!, child: content),
      ],
    );
  }
}
