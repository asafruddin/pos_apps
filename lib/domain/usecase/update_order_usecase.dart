import 'package:pos_app/domain/entity/order_entity.dart';
import 'package:pos_app/domain/repository/repository.dart';

class UpdateOrderUseCase {
  final Repository repository;

  UpdateOrderUseCase({required this.repository});

  Future<int?> execute(OrderEntity order) async {
    return repository.updateOrder(order);
  }
}
