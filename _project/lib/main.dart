import 'dart:io';

import 'package:_project/employee.dart';
import 'package:_project/employee_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
// ignore: library_prefixes
import 'package:path_provider/path_provider.dart' as pathProvider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(EmployeeAdapter());
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      debugShowCheckedModeBanner: false,
      home: EmployeesListScreen(),
    );
  }
}
