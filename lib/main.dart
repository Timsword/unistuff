import 'package:firebase_core/firebase_core.dart';
import 'package:first_unistaff_project/models/myuser.dart';
import 'package:first_unistaff_project/screens/wrapper.dart';
import 'package:first_unistaff_project/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'nav.dart';
import 'image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniStuff',
      home: Nav(),
    );
  }
}
