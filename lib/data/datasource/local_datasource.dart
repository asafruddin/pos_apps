// ignore_for_file: non_constant_identifier_names

//dbhelper ini dibuat untuk
//membuat database, membuat tabel, proses insert, read, update dan delete

import 'dart:developer';

import 'package:pos_app/core/local_storage.config.dart';
import 'package:pos_app/data/model/order_model.dart';

class LocalDatasource {
  final LocalStorageConfig database;

  //inisialisasi beberapa variabel yang dibutuhkan
  final String _orderTable = 'order_table';

  final String _productTable = 'product_table';
  final String _productOrderId = 'order_id';

  LocalDatasource({required this.database});

  //insert ke database
  Future<int> saveOrder(OrderModel order) async {
    try {
      final dbClient = await database.db;
      await dbClient!.insert(_orderTable, order.toMap());
      order.products?.forEach((element) async {
        await dbClient.insert(_productTable, element.toMap());
      });
      return order.id!;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<OrderModel>?> getOrder() async {
    try {
      final dbClient = await database.db;

      final orderResult =
          await dbClient?.rawQuery('SELECT * FROM $_orderTable');

      if (orderResult?.isEmpty ?? true) return null;

      final result = <OrderModel>[];

      for (var e in orderResult ?? []) {
        final products = await dbClient?.rawQuery(
            'SELECT * FROM $_productTable WHERE $_productOrderId = ${e['id']}');

        final orderMap = <String, dynamic>{};
        (e as Map<String, dynamic>).forEach((key, value) {
          orderMap[key] = value;
        });

        orderMap['products'] = products;

        result.add(OrderModel.fromJson(orderMap));
      }

      return result;
    } catch (e, s) {
      log(s.toString());
      log(s.toString());
      rethrow;
    }
  }

  Future<OrderModel?> getLastOrder() async {
    try {
      final dbClient = await database.db;
      final result = await dbClient?.rawQuery(
          'SELECT * FROM $_orderTable WHERE id = (SELECT MAX(id) from $_orderTable);');

      if (result?.isEmpty ?? true) return null;

      final resultMap = result?.first as Map<String, dynamic>;

      return OrderModel.fromJson(resultMap);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      rethrow;
    }
  }

  Future<int?> updateOrder(OrderModel order) async {
    var dbClient = await database.db;
    await dbClient?.update(_orderTable, order.toMap(),
        where: 'id = ?', whereArgs: [order.id]);

    await dbClient?.delete(_productTable,
        where: 'order_id = ?', whereArgs: [order.id]).then((value) {
      order.products?.forEach((element) async {
        await dbClient.insert(_productTable, element.toMap());
      });
    });

    return order.id;
  }

  Future<void> deleteOrder(int id) async {
    try {
      var dbClient = await database.db;

      await dbClient!.delete(_orderTable, where: 'id = ?', whereArgs: [id]);
      await dbClient
          .delete(_productTable, where: 'order_id = ?', whereArgs: [id]);
    } catch (e) {
      rethrow;
    }
  }
}
