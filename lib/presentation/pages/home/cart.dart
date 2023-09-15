import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/currency_formater.dart';
import 'package:pos_app/presentation/bloc/product/product_bloc.dart';
import 'package:pos_app/presentation/widget/theme.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == ProductStatus.productsClear) Navigator.pop(context);
      },
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Keranjang Pesanan',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: CustomTheme.primary),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: CustomTheme.primary,
                        ))
                  ],
                ),
              ),
              const Divider(height: 0, color: CustomTheme.neutral200),
              const SizedBox(height: 8.0),
              Center(
                child: InkWell(
                  onTap: () {
                    context.read<ProductBloc>().add(ClearCartEvent());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Kosongkan Keranjang',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.red),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              ...state.selectedProducts
                  .map((e) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: CustomTheme.neutral200))),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          leading: Image.asset(e.assets ?? ''),
                          title: Text(
                            e.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            e.price.toCurrencyFormatted(),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          trailing: TrailingCartButton(
                            onDecrease: () {
                              context.read<ProductBloc>().add(
                                  UpdateSelectedProductEvent(
                                      product: e, isIncreaseProduct: false));
                            },
                            onIncrease: () {
                              context
                                  .read<ProductBloc>()
                                  .add(UpdateSelectedProductEvent(product: e));
                            },
                            onDelete: () {
                              context
                                  .read<ProductBloc>()
                                  .add(RemoveProductEvent(id: e.id));
                            },
                            quantity: e.qty.toString(),
                          ),
                        ),
                      ))
                  .toList(),
              const SizedBox(height: 16.0),
            ],
          );
        },
      ),
    );
  }
}

class TrailingCartButton extends StatelessWidget {
  const TrailingCartButton(
      {super.key,
      required this.onDecrease,
      required this.onIncrease,
      required this.onDelete,
      required this.quantity});

  final Function() onDecrease;
  final Function() onIncrease;
  final Function() onDelete;
  final String quantity;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
                onTap: onDecrease,
                child: const Icon(
                  Icons.remove_circle_outline_rounded,
                  color: CustomTheme.primary,
                )),
            const SizedBox(width: 8.0),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return Text(
                  quantity,
                  style: Theme.of(context).textTheme.titleMedium,
                );
              },
            ),
            const SizedBox(width: 8.0),
            InkWell(
                onTap: onIncrease,
                child: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: CustomTheme.primary,
                ))
          ],
        ),
        InkWell(
          onTap: onDelete,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Hapus',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Colors.red),
            ),
          ),
        )
      ],
    );
  }
}
