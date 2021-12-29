import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:unistuff_main/screens/home/add_stuff_form.dart';
import 'package:unistuff_main/services/auth.dart';
import 'package:unistuff_main/services/database.dart';
import 'package:provider/provider.dart';
import 'package:unistuff_main/screens/home/stuff_list.dart';
import 'package:unistuff_main/models/stuff.dart';
import 'profile_sheet.dart';
import 'package:unistuff_main/screens/home/update_stuff_form.dart';

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

class _Home extends StatefulWidget {
  //const Home({Key? key}) : super(key: key);

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
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

    var _instance = FirebaseFirestore.instance;
    FirebaseAuth auth_ = FirebaseAuth.instance;
    File? image;
    String? downloadLink;
    Future pickImage() async {
      var fileToUpload =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) print("Bu değer yok");
      setState(() {
        image = File(fileToUpload!.path);
        print("Deneme amaçlı" + image.toString());
      });

      Reference referenceWay = FirebaseStorage.instance
          .ref()
          .child('profilePics')
          .child(auth_.currentUser!.uid)
          .child("profilPic.png");

      UploadTask uploadTask = referenceWay.putFile(image!);
      TaskSnapshot downloadURL = (await uploadTask);
      String url = await downloadURL.ref.getDownloadURL();
    }

    /*final picker = ImagePicker();
    File? _imageFile;
    Future pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      setState(() {
        _imageFile = File(pickedFile!.path);
      });
    }

    Future uploadImageToFirebase(BuildContext context) async {
      String fileName = (_imageFile!.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask;
      taskSnapshot.ref.getDownloadURL().then(
            (value) => print("Done: $value"),
          );
    }*/

    return StreamProvider<List<Stuff>?>.value(
      initialData: null,
      value: DatabaseService().stuffs,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  /*XFile? imageXFile;
                  final ImagePicker _picker = ImagePicker();
                  String sellerImageURL = '';
                  String fileName =
                      DateTime.now().microsecondsSinceEpoch.toString();
                  Reference reference2 = FirebaseStorage.instance
                      .ref()
                      .child('profilePics')
                      .child(fileName);
                  UploadTask uploadTask2 =
                      reference2.putFile(File(imageXFile!.path));
                  TaskSnapshot taskSnapshot2 =
                      await uploadTask2.whenComplete(() {});
                  await taskSnapshot2.ref.getDownloadURL().then((url) {
                    sellerImageURL = url;

                    //save info to firestore
                  });*/
                  pickImage();
                },
                child: Text('Profil resmi yükle')),
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
