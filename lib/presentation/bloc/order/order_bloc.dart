import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_app/domain/entity/order_entity.dart';
import 'package:pos_app/domain/usecase/delete_order_saved_usecase.dart';
import 'package:pos_app/domain/usecase/get_order_saved_usecase.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrderSavedUseCase getOrderSavedUseCase;
  final DeleteOrderSavedUseCase deleteUseCase;

  OrderBloc(this.getOrderSavedUseCase, this.deleteUseCase)
      : super(OrderState.initial()) {
    on<GetOrderSavedEvent>(getOrderSaved);
    on<DeleteOrderSavedEvent>(deleteOrderSaved);
    on<UpdateActionEvent>((event, emit) {
      final order =
          state.orderSaved.where((element) => element.id == event.orderId);

      emit(state.copyWith(isUpdate: true, updateOrder: order.first));
    });
  }
  Future<void> getOrderSaved(
      GetOrderSavedEvent event, Emitter<OrderState> emit) async {
    try {
      emit(state.copyWith(
          getOrderStatus: GetOrderStatus.loading,
          isUpdate: false,
          updateOrder: null));

      final result = await getOrderSavedUseCase.execute();

      emit(state.copyWith(orderSaved: result));
    } catch (e) {
      emit(state.copyWith(getOrderStatus: GetOrderStatus.error));
    }
  }

  Future<void> deleteOrderSaved(
      DeleteOrderSavedEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(
        deleteStatus: DeleteStatus.deleting,
        isUpdate: false,
        updateOrder: null));
    try {
      deleteUseCase.execute(event.orderId);
      add(GetOrderSavedEvent());

      emit(state.copyWith(deleteStatus: DeleteStatus.deleted));
    } catch (e) {
      emit(state.copyWith());
    }
  }
}
