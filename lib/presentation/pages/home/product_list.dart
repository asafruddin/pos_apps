import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/presentation/bloc/product/product_bloc.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return GridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          crossAxisCount: 3,
          childAspectRatio: 0.8,
          children: List.generate(state.products.length, (i) {
            final product = state.products[i];
            return InkWell(
              onTap: () {
                context
                    .read<ProductBloc>()
                    .add(UpdateSelectedProductEvent(product: product));
              },
              borderRadius: BorderRadius.circular(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(product.assets ?? ''),
                  const SizedBox(height: 5.0),
                  Text(
                    product.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
