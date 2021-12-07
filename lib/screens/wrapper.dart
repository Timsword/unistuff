import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unistuff_main/screens/authenticate/authenticate.dart';
import 'package:unistuff_main/screens/home/home.dart';
import 'package:unistuff_main/models/myuser.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    print(user);

    //return etiher home or authenticate widget??
    return Authenticate();
  }
}
