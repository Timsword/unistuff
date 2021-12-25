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
  final List<String> categories = ["Spor", "Vasıta", "Elektronik"];
  addStuff() {
    FirebaseFirestore.instance.collection('Stuffs').doc(_currentTitle).set({
      'title': _currentTitle,
      'details': _currentDetails,
      'price': _currentPrice,
      'category': _currentCategory
    });
  }

  bool validatePrice(String str) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    return _numeric.hasMatch(str);
  }

  String title = '';
  String details = '';
  String category = '';
  String price = "";

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
                addStuff();
              },
            ),
          ],
        ),
      ),
    );
  }
}
