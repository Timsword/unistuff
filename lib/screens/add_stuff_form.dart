import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddStuffForm extends StatefulWidget {
  const AddStuffForm({Key? key}) : super(key: key);

  @override
  _AddStuffFormState createState() => _AddStuffFormState();
}

class _AddStuffFormState extends State<AddStuffForm> {
  final _formkey = GlobalKey<FormState>();
  final List<String> categories = ["Spor", "Vasıta", "Elektronik"];
  addStuff() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final _uid = user!.uid;
    String _stuffID = Uuid().v4();
    String _dateTime = DateTime.now().toString();
    FirebaseFirestore.instance.collection('stuffs').doc(_stuffID).set({
      'stuffID': _stuffID,
      'title': _currentTitle,
      'details': _currentDetails,
      'price': _currentPrice,
      'category': _currentCategory,
      'favoriteNumber': 0,
      'dateTime': _dateTime,
      'userID': _uid,
      'soldOrNot': 'in sale',
    });
    return _stuffID;
  }

  var _instance = FirebaseFirestore.instance;
  FirebaseAuth auth_ = FirebaseAuth.instance;
  File? image;
  String? downloadLink;
  Future pickStuffImage() async {
    var fileToUpload =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) print("null don");
    setState(() {
      image = File(fileToUpload!.path);
    });
    return image;
  }

  Future addStuffImageToDatabase(stuffID, image) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;
    Reference referenceWay = FirebaseStorage.instance
        .ref()
        .child('stuffPics')
        .child(uid)
        .child(stuffID)
        .child("stuffPic.png");

    UploadTask uploadTask = referenceWay.putFile(image!);
    TaskSnapshot downloadURL = (await uploadTask);
    String url = await downloadURL.ref.getDownloadURL();
    FirebaseFirestore.instance
        .collection('stuffs')
        .doc(stuffID)
        .update({'stuffImage': url});
  }

  storeImage(image) async {
    return image;
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
              'Add your stuff info',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(
                  fillColor: Colors.brown, hintText: 'Title', filled: true),
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
                  fillColor: Colors.brown, hintText: 'Details', filled: true),
              validator: (val) =>
                  val!.isEmpty ? 'Lütfen bir açıklama giriniz' : null,
              onChanged: (val) => setState(() => _currentDetails = val),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(
                  fillColor: Colors.brown, hintText: 'Price', filled: true),
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
            TextButton.icon(
              icon: Icon(Icons.image),
              label: Text('Gallery'),
              onPressed: () {
                Future<dynamic> image = (pickStuffImage());
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text('Camera'),
              onPressed: () {
                Future<dynamic> image = (pickStuffImage());
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.pink[400],
              ),
              child: Text('Ekle', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                addStuffImageToDatabase(addStuff(), image);
              },
            ),
          ],
        ),
      ),
    );
  }
}
