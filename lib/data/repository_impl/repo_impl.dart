import 'package:intl/intl.dart';
import 'package:pos_app/data/datasource/local_datasource.dart';
import 'package:pos_app/data/model/order_model.dart';
import 'package:pos_app/domain/entity/order_entity.dart';
import 'package:pos_app/domain/entity/product_list_entity.dart';
import 'package:pos_app/domain/repository/repository.dart';

class RepoImplementation implements Repository {
  final LocalDatasource datasource;

  RepoImplementation({required this.datasource});

  @override
  Future<int> saveOrder(List<ProductEntity> orders) async {
    try {
      final lastOrder = await datasource.getLastOrder();

      int newId = 1;
      String newOrderNo = 'TRX ID 1';

      if (lastOrder != null) {
        newId = lastOrder.id! + 1;
        final no = int.parse(lastOrder.orderNo!.split(' ').last);

        newOrderNo = 'TRX ID ${no + 1}';
      }

      final totalPrice =
          orders.fold(0, (prev, e) => prev + ((e.qty ?? 0) * e.price.toInt()));

      final body = OrderModel(
          id: newId,
          orderNo: newOrderNo,
          date: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
          totalPrice: totalPrice,
          products: orders
              .map((e) => ProductModel(
                  orderId: newId,
                  id: e.id,
                  price: e.price.toInt(),
                  name: e.name,
                  qty: e.qty))
              .toList());

      final result = await datasource.saveOrder(body);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<OrderEntity>> getSavedOrder() async {
    try {
      final result = await datasource.getOrder();

      return result?.map((e) => e.toEntity()).toList() ?? [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteOrder(int orderId) async {
    try {
      await datasource.deleteOrder(orderId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int?> updateOrder(OrderEntity order) async {
    try {
      final body = OrderModel(
        id: order.id,
        orderNo: order.orderNo,
        date: DateFormat('yyyy-MM-dd HH:mm').format(order.orderDate),
        totalPrice: order.totalPrice,
        products: order.products
            .map((e) => ProductModel(
                orderId: order.id,
                id: e.id,
                price: e.price.toInt(),
                name: e.name,
                qty: e.qty))
            .toList(),
      );

      final result = await datasource.updateOrder(body);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
