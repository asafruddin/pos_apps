import 'package:pos_app/domain/entity/product_list_entity.dart';
import 'package:pos_app/domain/repository/repository.dart';

class SaveOrderUseCase {
  final Repository repository;

  SaveOrderUseCase({required this.repository});

  Future<int> execute(List<ProductEntity> orders) async {
    return repository.saveOrder(orders);
  }
}
