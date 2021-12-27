import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:unistuff_main/screens/home/stuff_form.dart';
import 'package:unistuff_main/services/auth.dart';
import 'package:unistuff_main/services/database.dart';
import 'package:provider/provider.dart';
import 'package:unistuff_main/screens/home/stuff_list.dart';
import 'package:unistuff_main/models/stuff.dart';
import 'profile_sheet.dart';

/*void newStuff(String text) {
  var stuff = new Stuff(text, widget.name);
  stuff.setId(saveStuff(stuff));
  this.setState(() {
    stuffs.add(stuff);
  });
}*/

class Home extends StatelessWidget {
  //const _Home({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Home(),
    );
  }
}

class _Home extends StatelessWidget {
  //const Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();
  var getTitle = '';
  var getDetails = '';
  var getPrice = '';
  var getCategory = '';
  var getFavoriteNo = '';
  var dateTime = '';
  var userID = '';

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('Stuffs').snapshots();

    void _addStuff(BuildContext context) {
      //stuff_form'a yönlendirme.
      showModalBottomSheet<dynamic>(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                child: StuffForm());
          });
    }

    void _viewProfile(BuildContext context) {
      showModalBottomSheet<dynamic>(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                child: profileSheet());
          });
    }

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
            ),
            TextButton.icon(
              icon: Icon(Icons.add),
              label: Text('Ürün ekle'),
              onPressed: () => _addStuff(context),
            ),
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('Profil'),
              onPressed: () => _viewProfile(context),
            )
          ],
        ),
        body: StuffList(),
      ),
    );
  }
}
