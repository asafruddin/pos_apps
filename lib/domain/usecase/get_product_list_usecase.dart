import 'package:pos_app/domain/entity/product_list_entity.dart';

class GetProductListUseCase {
  Future<List<ProductEntity>> getProductEntity() async {
    return dummyData;
  }
}

final dummyData = [
  const ProductEntity(
      name: 'Ayam Goreng Pedas',
      id: 1,
      assets: 'assets/img/img_product_1.png',
      price: 20000),
  const ProductEntity(
      name: 'Ayam Geprek',
      id: 2,
      assets: 'assets/img/img_product_2.png',
      price: 18000),
  const ProductEntity(
      name: 'Tahu Sumedang',
      id: 3,
      assets: 'assets/img/img_product_1.png',
      price: 15000),
  const ProductEntity(
      name: 'Tahu Bakso',
      id: 4,
      assets: 'assets/img/img_product_2.png',
      price: 15500),
];
