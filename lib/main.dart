import 'package:flutter/material.dart';
import 'package:unistuff_main/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:unistuff_main/services/auth.dart';
import 'package:unistuff_main/models/myuser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      catchError: (_, __) => null,
      initialData: AuthService().user,
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
