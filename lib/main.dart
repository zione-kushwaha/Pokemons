import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pp1/pages/home_page.dart';
import 'package:pp1/service/database_service.dart';

import 'service/http_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupServices();
  runApp(const MyApp());
}

Future<void> _setupServices() async {
  GetIt.instance.registerSingleton<HttpService>(HttpService());
  GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              centerTitle: true,
            ),
          ),
          home: const HomePage()),
    );
  }
}
