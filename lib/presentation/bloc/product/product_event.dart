part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class GetProductsEvent extends ProductEvent {}

class UpdateSelectedProductEvent extends ProductEvent {
  final ProductEntity product;
  final bool isIncreaseProduct;

  UpdateSelectedProductEvent(
      {required this.product, this.isIncreaseProduct = true});
}

class RemoveProductEvent extends ProductEvent {
  final int id;

  RemoveProductEvent({required this.id});
}

class ClearCartEvent extends ProductEvent {}

class SaveOrderEvent extends ProductEvent {}

class UpdateCartEvent extends ProductEvent {
  final List<ProductEntity> products;
  final int orderId;
  final String orderNo;

  UpdateCartEvent(
      {required this.products, required this.orderId, required this.orderNo});
}
