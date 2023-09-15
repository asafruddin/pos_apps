import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String name;
  final double price;
  final String? assets;
  final int id;
  final int? qty;

  const ProductEntity(
      {required this.name,
      required this.id,
      this.assets,
      this.qty,
      required this.price});

  @override
  List<Object?> get props => [name, assets, id, qty, price];

  ProductEntity copyWith({int? quantity}) {
    return ProductEntity(
        name: name, id: id, assets: assets, qty: quantity, price: price);
  }
}
