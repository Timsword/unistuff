import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formkey = GlobalKey<FormState>();

  addStuff() {
    FirebaseFirestore.instance
        .collection('Stuffs')
        .doc(_currentTitle)
        .set({'title': _currentTitle, 'details': _currentDetails});
  }

  String title = '';
  String details = '';
  String category = '';

  //form values
  String? _currentTitle;
  String? _currentDetails;
  int? _currentPrice;

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
              validator: (val) =>
                  val!.isEmpty ? 'Lütfen bir başlık giriniz' : null,
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
              onChanged: (val) => setState(() => _currentPrice = val as int?),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.pink[400],
              ),
              child: Text('Ekle', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                addStuff();
                print(_currentTitle);
                print(_currentDetails);
              },
            ),
          ],
        ),
      ),
    );
  }
}
