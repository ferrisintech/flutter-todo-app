import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scrumme/models/list_model.dart';
import 'package:scrumme/models/ticket_model.dart';

import 'home/backlog.dart';
import 'provider/db_provider.dart';


void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(TicketModelAdapter());
  await Hive.openBox<CategoryModel>('catBox');
  await Hive.openBox<TicketModel>('ticBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.black));

    return ChangeNotifierProvider<DatabaseProvider>(
      create: (_) => DatabaseProvider(),
      child: MaterialApp(
   // return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF512DA8),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: const BacklogPage(),
      ),
    );
  }
}


