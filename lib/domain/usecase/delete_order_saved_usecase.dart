import 'package:pos_app/domain/repository/repository.dart';

class DeleteOrderSavedUseCase {
  final Repository repository;

  DeleteOrderSavedUseCase({required this.repository});

  Future<void> execute(int orderId) async {
    return repository.deleteOrder(orderId);
  }
}
