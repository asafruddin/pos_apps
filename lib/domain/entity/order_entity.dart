import 'package:equatable/equatable.dart';
import 'package:pos_app/domain/entity/product_list_entity.dart';

class OrderEntity extends Equatable {
  final int id;
  final String orderNo;
  final int totalPrice;
  final DateTime orderDate;
  final List<ProductEntity> products;

  const OrderEntity(
      {required this.id,
      required this.orderNo,
      required this.totalPrice,
      required this.orderDate,
      required this.products});

  @override
  List<Object?> get props => [id, orderNo, totalPrice, products];
}
