part of 'order_bloc.dart';

enum GetOrderStatus { init, loading, loaded, error }

enum DeleteStatus { init, deleting, deleted, errorDelete }

class OrderState extends Equatable {
  final List<OrderEntity> orderSaved;
  final GetOrderStatus getOrderStatus;
  final DeleteStatus deleteStatus;
  final bool isUpdate;
  final OrderEntity? updateOrder;

  const OrderState(
      {required this.orderSaved,
      required this.getOrderStatus,
      required this.deleteStatus,
      required this.isUpdate,
      this.updateOrder});

  @override
  List<Object?> get props =>
      [orderSaved, getOrderStatus, deleteStatus, isUpdate, updateOrder];

  factory OrderState.initial() => const OrderState(
      orderSaved: [],
      getOrderStatus: GetOrderStatus.init,
      deleteStatus: DeleteStatus.init,
      isUpdate: false);

  OrderState copyWith(
      {List<OrderEntity>? orderSaved,
      GetOrderStatus? getOrderStatus,
      DeleteStatus? deleteStatus,
      bool? isUpdate,
      OrderEntity? updateOrder}) {
    return OrderState(
        orderSaved: orderSaved ?? this.orderSaved,
        getOrderStatus: getOrderStatus ?? this.getOrderStatus,
        deleteStatus: deleteStatus ?? this.deleteStatus,
        isUpdate: isUpdate ?? this.isUpdate,
        updateOrder: updateOrder);
  }
}
