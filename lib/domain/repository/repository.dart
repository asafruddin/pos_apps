import 'package:pos_app/domain/entity/order_entity.dart';
import 'package:pos_app/domain/entity/product_list_entity.dart';

abstract class Repository {
  Future<int> saveOrder(List<ProductEntity> order);
  Future<List<OrderEntity>> getSavedOrder();
  Future<void> deleteOrder(int orderId);
  Future<int?> updateOrder(OrderEntity order);
}
