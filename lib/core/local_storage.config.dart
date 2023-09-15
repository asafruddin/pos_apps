import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalStorageConfig {
  static final LocalStorageConfig _instance = LocalStorageConfig._internal();
  static Database? _database;

  //Init table name and column name
  final String orderTable = 'order_table';
  final String orderId = 'id';
  final String orderNo = 'order_no';
  final String orderDate = 'order_date';
  final String totalPrice = 'total_price';

  final String productTable = 'product_table';
  final String productOrderId = 'order_id';
  final String productId = 'id';
  final String productPrice = 'price';
  final String productName = 'name';
  final String productQty = 'quantity';

  LocalStorageConfig._internal();
  factory LocalStorageConfig() => _instance;

  Future<Database?> get db async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDb();
    return _database;
  }

  Future<Database?> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'pos.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  /// create table and column
  Future<void> _onCreate(Database db, int version) async {
    var sqlOrder = "CREATE TABLE $orderTable($orderId INTEGER PRIMARY KEY, "
        "$orderNo TEXT,"
        "$orderDate TEXT,"
        "$totalPrice INTEGER)";

    var sqlProduct =
        "CREATE TABLE $productTable($productOrderId INTEGER, $productId INTEGER, "
        "$productPrice INTEGER,"
        "$productName TEXT,"
        "$productQty INTEGER)";

    await db.execute(sqlOrder);
    await db.execute(sqlProduct);
  }
}
