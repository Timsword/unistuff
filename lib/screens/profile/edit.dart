import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_unistaff_project/screens/home/menu.dart';
import 'package:first_unistaff_project/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../settings.dart';

class EditProfilePageState extends StatefulWidget {
  @override
  _EditProfilePageState createState() {
    return _EditProfilePageState();
  }
}

class SettingsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "setting UI",
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;

  get boxshape => null;
  final AuthService _auth = AuthService();

  var getName = '';
  var getImage = '';
  var getEmail = '';
  var getLocation = '';
  var getUniversity = '';
  String name = '';
  String location = '';
  String university = '';

  updateUserInfo() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final _uid = user!.uid;
    FirebaseFirestore.instance.collection('users').doc(userID).update({
      'name': name,
      'location': location,
      'university': university,
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userID = user!.uid;

    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .get()
        .then((gelenVeri) {
      setState(() {
        getName = gelenVeri.data()!['name'];
        getImage = gelenVeri.data()!['profileImage'];
        getEmail = gelenVeri.data()!['email'];
        getUniversity = gelenVeri.data()!['university'];
        getLocation = gelenVeri.data()!['location'];
      });
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.deepPurple,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.deepPurple,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(getImage),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Colors.grey,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Text('Full Name'),
              TextFormField(
                decoration: InputDecoration(
                  labelText: getName,
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  val!.isEmpty ? null : setState(() => name = val);
                },
              ),
              Text('Location'),
              TextFormField(
                decoration: InputDecoration(
                  labelText: getLocation,
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  val!.isEmpty ? null : setState(() => location = val);
                },
              ),
              Text('University'),
              TextFormField(
                decoration: InputDecoration(
                  labelText: getUniversity,
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  val!.isEmpty
                      ? setState(() => university = getUniversity)
                      : setState(() => university = val);
                },
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          updateUserInfo();
                        },
                        color: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
