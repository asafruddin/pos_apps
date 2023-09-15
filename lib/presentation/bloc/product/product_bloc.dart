import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pos_app/domain/entity/order_entity.dart';
import 'package:pos_app/domain/entity/product_list_entity.dart';
import 'package:pos_app/domain/usecase/get_product_list_usecase.dart';
import 'package:pos_app/domain/usecase/save_order_usecase.dart';
import 'package:pos_app/domain/usecase/update_order_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductListUseCase getProducts;
  final SaveOrderUseCase saveUseCase;
  final UpdateOrderUseCase updateUseCase;

  ProductBloc(this.getProducts, this.saveUseCase, this.updateUseCase)
      : super(ProductState.inital()) {
    on<GetProductsEvent>(getProductsEvent);
    on<UpdateSelectedProductEvent>(updateSelectedProduct);
    on<RemoveProductEvent>(removeProduct);
    on<ClearCartEvent>(clearCart);
    on<SaveOrderEvent>(actionOrder);
    on<UpdateCartEvent>(updateCart);
  }

  Future<void> getProductsEvent(
      GetProductsEvent event, Emitter<ProductState> emit) async {
    final result = await getProducts.getProductEntity();

    emit(state.copyWith(products: result, selectedProduct: []));
  }

  Future<void> updateSelectedProduct(
      UpdateSelectedProductEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.productInit));

    final productIdx = getCurrentIndex(state, event.product.id);

    final selectedProducts = state.selectedProducts;

    if (productIdx > -1) {
      final currentQty = selectedProducts[productIdx].qty;
      final products = selectedProducts[productIdx];
      if (event.isIncreaseProduct) {
        selectedProducts[productIdx] =
            products.copyWith(quantity: (currentQty ?? 0) + 1);
        emit(state.copyWith(
            selectedProduct: selectedProducts,
            status: ProductStatus.productQtyAdd));
        return;
      }

      if (currentQty == 1 && !event.isIncreaseProduct) {
        selectedProducts.removeAt(productIdx);
        emit(state.copyWith(
            selectedProduct: selectedProducts,
            status: selectedProducts.isEmpty
                ? ProductStatus.productsClear
                : ProductStatus.productRemove));
        return;
      }

      selectedProducts[productIdx] =
          products.copyWith(quantity: (currentQty ?? 0) - 1);

      emit(state.copyWith(
          selectedProduct: selectedProducts,
          status: ProductStatus.productQtyRemove));
      return;
    }
    selectedProducts.add(event.product.copyWith(quantity: 1));

    emit(state.copyWith(
        selectedProduct: selectedProducts, status: ProductStatus.productAdd));
  }

  Future<void> removeProduct(
      RemoveProductEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.productInit));
    final productIdx = getCurrentIndex(state, event.id);
    final products = state.selectedProducts;

    if (productIdx > -1) {
      products.removeAt(productIdx);
      emit(state.copyWith(
          selectedProduct: products,
          status: products.isEmpty
              ? ProductStatus.productsClear
              : ProductStatus.productRemove));
    }
  }

  Future<void> clearCart(
      ClearCartEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.productInit));
    final products = state.selectedProducts;

    products.clear();
    emit(state.copyWith(
        selectedProduct: products, status: ProductStatus.productsClear));
  }

  Future<void> actionOrder(
      SaveOrderEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(saveStatus: SaveStatus.saving));

    try {
      int orderId = -1;
      if (state.isUpdate) {
        final totalPrice = state.selectedProducts
            .fold(0, (prev, e) => prev + ((e.qty ?? 0) * e.price.toInt()));

        final order = OrderEntity(
            id: state.orderId,
            orderNo: state.orderNo,
            totalPrice: totalPrice,
            orderDate: DateTime.now(),
            products: state.selectedProducts);

        orderId = await updateUseCase.execute(order) ?? -1;
      } else {
        orderId = await saveUseCase.execute(state.selectedProducts);
      }

      emit(state.copyWith(
          saveStatus: SaveStatus.saved, orderId: orderId, isUpdate: false));
    } catch (e) {
      emit(state.copyWith(saveStatus: SaveStatus.errorSave));
    }
  }

  Future<void> updateCart(
      UpdateCartEvent event, Emitter<ProductState> emit) async {
    final products = <ProductEntity>[];

    for (var e in state.products) {
      final idx = event.products.indexWhere((element) => element.id == e.id);
      if (idx > -1) {
        products.add(e.copyWith(quantity: event.products[idx].qty));
      }
    }

    emit(state.copyWith(
        selectedProduct: products,
        orderId: event.orderId,
        isUpdate: true,
        status: ProductStatus.productAdd));

    // print('---> ${state.selectedProducts}');
  }

  int getCurrentIndex(ProductState state, int idProduct) {
    final index =
        state.selectedProducts.indexWhere((element) => element.id == idProduct);
    return index;
  }
}
