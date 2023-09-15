import 'package:pos_app/domain/entity/order_entity.dart';
import 'package:pos_app/domain/repository/repository.dart';

class GetOrderSavedUseCase {
  final Repository repository;

  GetOrderSavedUseCase({required this.repository});

  Future<List<OrderEntity>> execute() async {
    return repository.getSavedOrder();
  }
}
