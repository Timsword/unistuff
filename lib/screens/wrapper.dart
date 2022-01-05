import 'package:first_unistaff_project/screens/home/menu.dart';
import 'package:first_unistaff_project/models/myuser.dart';
import 'package:first_unistaff_project/screens/authenticate/log_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    print(user);

    //return either home or authenticate widget??
    if (user == null) {
      return Login();
    } else {
      return MainPage();
    }
  }
}
