import "package:flutter/material.dart";
import 'package:unistuff_main/services/auth.dart';
import 'package:unistuff_main/services/database.dart';
import 'package:provider/provider.dart';
import 'package:unistuff_main/screens/home/stuff_list.dart';
import 'package:unistuff_main/models/stuff.dart';

class Home extends StatelessWidget {
  //const Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Stuff>?>.value(
      initialData: null,
      value: DatabaseService().stuffs,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Unistuff'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('Çıkış yap'),
              onPressed: () async {
                await _auth.signOut();
              },
            )
          ],
        ),
        body: StuffList(),
      ),
    );
  }
}
