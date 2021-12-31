import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unistuff_main/models/stuff.dart';
//import 'package:unistuff_main/screens/home/profile_sheet.dart';

class updateStuffForm extends StatefulWidget {
  //const updateStuffForm({Key? key}) : super(key: key);
  final String? stuffID;
  updateStuffForm({Key? key, this.stuffID}) : super(key: key);

  @override
  _updateStuffFormState createState() => _updateStuffFormState();
}

class _updateStuffFormState extends State<updateStuffForm> {
  final _formkey = GlobalKey<FormState>();
  final List<String> categories = ["Spor", "Vasıta", "Elektronik"];

  /*hatalı
  get_StuffID() {
    Widget build(BuildContext context) {
      return new StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Stuffs')
              .doc('stuffID')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new Text("Loading");
            }
            var userDocument = snapshot.data;
            return (userDocument["name"]);
          });
    }
  }*/

  editStuff(stuffID) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final _uid = user!.uid;
    FirebaseFirestore.instance.collection('Stuffs').doc(stuffID).update({
      'title': _currentTitle,
      'details': _currentDetails,
      'price': _currentPrice,
      'category': _currentCategory,
      'userID': _uid
    });
  }

  /*getData(stuffID) async {
    return await FirebaseFirestore.instance
        .collection('Stuffs')
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        print(value.doc(stuffID).data()['title'] ?? '');
      } else {
        print("Not Found");
      }
    });
  }*/

  /*fetchStuff(stuffID) async {
    var userKey;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('stuffID')
        .doc(stuffID)
        .get();
    print(snapshot.data()!['title'] ?? '');

    return userKey['title'].toString();
  }*/

  bool validatePrice(String str) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    return _numeric.hasMatch(str);
  }

  //form values
  String? _currentTitle;
  String? _currentDetails;
  String? _currentPrice;
  String? _currentCategory;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              'Eşya bilgilerini girin',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(
                  fillColor: Colors.brown, hintText: 'Başlık', filled: true),
              validator: (val) {
                if ((validatePrice(val!) == false)) {
                  return "Lütfen bir sayı giriniz";
                }
                if (val.isEmpty == true) {
                  return "Lütfen bir fiyat giriniz";
                }
                return null;
              },
              onChanged: (val) => setState(() => _currentTitle = val),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 1, //Normal textInputField will be displayed
              maxLines: 5,
              decoration: InputDecoration(
                  fillColor: Colors.brown, hintText: 'Detaylar', filled: true),
              validator: (val) =>
                  val!.isEmpty ? 'Lütfen bir açıklama giriniz' : null,
              onChanged: (val) => setState(() => _currentDetails = val),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(
                  fillColor: Colors.brown, hintText: 'Fiyat', filled: true),
              validator: (val) =>
                  val!.isEmpty ? 'Lütfen bir fiyat giriniz' : null,
              onChanged: (val) => setState(() => _currentPrice = val),
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField(
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text('$category'),
                );
              }).toList(),
              onChanged: (val) =>
                  setState(() => _currentCategory = val as String?),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.pink[400],
              ),
              child: Text('Ekle', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                editStuff(widget.stuffID);
              },
            ),
          ],
        ),
      ),
    );
  }
}
