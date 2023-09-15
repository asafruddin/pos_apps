part of 'product_bloc.dart';

enum ProductStatus {
  productAdd,
  productQtyAdd,
  productQtyRemove,
  productRemove,
  productsClear,
  productInit,
}

enum SaveStatus {
  init,
  saving,
  saved,
  errorSave,
}

class ProductState extends Equatable {
  final List<ProductEntity> products;
  final List<ProductEntity> selectedProducts;
  final ProductStatus status;
  final SaveStatus saveStatus;
  final int orderId;
  final bool isUpdate;
  final String orderNo;

  const ProductState({
    required this.products,
    required this.selectedProducts,
    required this.status,
    required this.saveStatus,
    required this.orderId,
    required this.isUpdate,
    required this.orderNo,
  });

  @override
  List<Object?> get props => [
        products,
        selectedProducts,
        status,
        saveStatus,
        orderId,
        isUpdate,
        orderNo
      ];

  factory ProductState.inital() => const ProductState(
      products: [],
      selectedProducts: [],
      status: ProductStatus.productInit,
      saveStatus: SaveStatus.init,
      orderId: 0,
      isUpdate: false,
      orderNo: '');

  ProductState copyWith(
      {List<ProductEntity>? products,
      List<ProductEntity>? selectedProduct,
      ProductStatus? status,
      SaveStatus? saveStatus,
      bool? isUpdate,
      int? orderId,
      String? orderNo}) {
    return ProductState(
        products: products ?? this.products,
        selectedProducts: selectedProduct ?? selectedProducts,
        status: status ?? this.status,
        saveStatus: saveStatus ?? this.saveStatus,
        orderId: orderId ?? this.orderId,
        isUpdate: isUpdate ?? this.isUpdate,
        orderNo: orderNo ?? this.orderNo);
  }
}
