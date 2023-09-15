import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/injector_container.dart';
import 'package:pos_app/presentation/bloc/order/order_bloc.dart';
import 'package:pos_app/presentation/pages/main_navigation.dart';
import 'package:pos_app/presentation/widget/theme.dart';
import 'package:pos_app/core/injector_container.dart' as di;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  runZonedGuarded(() async {
    sqfliteFfiInit();

    await di.init();
    runApp(const MainApp());
  }, (error, stack) {});
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderBloc>(),
      child:
          MaterialApp(theme: CustomTheme.theme, home: const MainNavigation()),
    );
  }
}
