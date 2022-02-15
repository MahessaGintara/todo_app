import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/views/start/splash_screen.dart';
import 'adapters/todo.dart';

void main() async {
  await Hive.initFlutter();

  await Hive.openBox('userBox');

  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(CategoryAdapter());
  await Hive.openBox<Todo>('todos');
  await Hive.openBox<Category>('categories');

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.pink));
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(1, 10, 67, 1),
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
