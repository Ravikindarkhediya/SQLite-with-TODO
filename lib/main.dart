import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_with_sqlite/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: ()=> HomeScreen()),
      ],
    );
  }
}