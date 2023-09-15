import 'package:get_it/get_it.dart';
import 'package:pos_app/core/local_storage.config.dart';
import 'package:pos_app/data/datasource/local_datasource.dart';
import 'package:pos_app/data/repository_impl/repo_impl.dart';
import 'package:pos_app/domain/repository/repository.dart';
import 'package:pos_app/domain/usecase/delete_order_saved_usecase.dart';
import 'package:pos_app/domain/usecase/get_order_saved_usecase.dart';
import 'package:pos_app/domain/usecase/get_product_list_usecase.dart';
import 'package:pos_app/domain/usecase/save_order_usecase.dart';
import 'package:pos_app/domain/usecase/update_order_usecase.dart';
import 'package:pos_app/presentation/bloc/order/order_bloc.dart';
import 'package:pos_app/presentation/bloc/product/product_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final localStorage = LocalStorageConfig();

  sl.registerLazySingleton(() => localStorage);

  sl.registerFactory(() => LocalDatasource(database: sl()));

  /// REPOSITORY
  sl.registerFactory<Repository>(() => RepoImplementation(datasource: sl()));

  /// USECASE
  sl.registerFactory(() => GetProductListUseCase());
  sl.registerFactory(() => SaveOrderUseCase(repository: sl()));
  sl.registerFactory(() => GetOrderSavedUseCase(repository: sl()));
  sl.registerFactory(() => DeleteOrderSavedUseCase(repository: sl()));
  sl.registerFactory(() => UpdateOrderUseCase(repository: sl()));

  /// BLOC
  sl.registerFactory(() => ProductBloc(sl(), sl(), sl()));
  sl.registerFactory(() => OrderBloc(sl(), sl()));
}
