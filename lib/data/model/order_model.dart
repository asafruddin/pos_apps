import 'package:pos_app/domain/entity/order_entity.dart';
import 'package:pos_app/domain/entity/product_list_entity.dart';

class OrderModel {
  final int? id;
  final String? orderNo;
  final String? date;
  final int? totalPrice;
  final List<ProductModel>? products;

  OrderModel(
      {required this.id,
      required this.orderNo,
      required this.date,
      required this.totalPrice,
      required this.products});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['order_no'] = orderNo;
    map['order_date'] = date;
    map['total_price'] = totalPrice;

    return map;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        id: json['id'],
        orderNo: json['order_no'],
        date: json['order_date'],
        totalPrice: json['total_price'],
        products: json['products'] == null
            ? null
            : (json['products'] as List)
                .map((e) => ProductModel.fromJson(e))
                .toList());
  }

  OrderEntity toEntity() {
    return OrderEntity(
        id: id!,
        orderDate: DateTime.parse(date!),
        orderNo: orderNo!,
        totalPrice: totalPrice!,
        products: products!.map((e) => e.toEntity()).toList());
  }
}

class ProductModel {
  final int? orderId;
  final int? id;
  final int? price;
  final String? name;
  final int? qty;

  ProductModel(
      {required this.orderId,
      required this.id,
      required this.price,
      required this.name,
      required this.qty});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['order_id'] = orderId;
    map['price'] = price;
    map['name'] = name;
    map['quantity'] = qty;

    return map;
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        orderId: json['order_id'],
        id: json['id'],
        price: json['price'],
        name: json['name'],
        qty: json['quantity']);
  }

  ProductEntity toEntity() {
    return ProductEntity(
        name: name!, id: id!, price: price!.toDouble(), qty: qty);
  }
}
