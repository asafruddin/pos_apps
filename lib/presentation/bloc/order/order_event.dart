part of 'order_bloc.dart';

class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class GetOrderSavedEvent extends OrderEvent {}

class DeleteOrderSavedEvent extends OrderEvent {
  final int orderId;

  const DeleteOrderSavedEvent({required this.orderId});
}

class UpdateActionEvent extends OrderEvent {
  final int orderId;

  const UpdateActionEvent({required this.orderId});
}
