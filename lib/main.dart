import 'package:flutter/material.dart';
import 'nav.dart';
import 'image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends
StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniStaff',
      home: Nav(),

    );
  }
}