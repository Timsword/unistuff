import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unistuff_main/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

/* String validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || !regex.hasMatch(value))
    return 'Enter a valid email address';
  else {
    return null;
  }
} */

class Register extends StatefulWidget {
  //const Register({Key? key}) : super(key: key);

  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //text field states
  String email = '';
  String name = '';
  String username = '';
  String password = '';
  String university = '';
  String error = '';
  String usernameError = 'false';
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  addUserToDatabase() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'username': username,
      'userID': uid,
      'university': university
    });
  }

  setUserID() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .update({'userID': uid});
  }

  Future<bool> usernameCheck(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return result.docs.isEmpty;
  }

  /*Future<bool> emailCheck(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('email_verification')
        .where('domain', isEqualTo: username)
        .get();
    return result.docs.isEmpty;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Unistuff\'a katıl!'),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Giriş yap'),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                  //username
                  decoration: InputDecoration(hintText: 'Ad soyad'),
                  validator: (val) => //boşsa uyarı
                      val!.isEmpty ? 'Lütfen bir isim giriniz' : null,
                  onChanged: (val) {
                    //get the text whenever value changed
                    setState(() => name = val);
                  }),
              SizedBox(height: 20.0),
              TextFormField(
                  //e-mail
                  decoration: InputDecoration(hintText: 'E-posta'),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Lütfen bir eposta giriniz';
                    } else {
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val);
                      if (!EmailValidator.validate(val)) {
                        return "Lütfen bir e-posta giriniz.";
                      }
                      int dotLength =
                          ('.'.allMatches(val..split("@").last).length);
                      if (dotLength == 1) {
                        //check database for ktu.edu
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.+edu+")
                            .hasMatch(val);
                        if (!emailValid) {
                          return "Lütfen bir üniversite e-postası girin.";
                        }
                      } else if (dotLength == 2) {
                        //check database for ktu.edu.tr
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.+edu+\.[a-zA-Z]+")
                            .hasMatch(val);
                        if (!emailValid) {
                          return "Lütfen bir üniversite e-postası girin.";
                        }
                      } else if (dotLength == 3) {
                        //check database for ogr.ktu.edu.tr
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+\.+edu+\.[a-zA-Z]+")
                            .hasMatch(val);
                        if (!emailValid) {
                          return "Lütfen bir üniversite e-postası girin.";
                        }
                      } else {
                        return "Bu e-posta şu anda desteklenmemektedir.";
                      }
                    }
                    null;
                  },
                  keyboardType: TextInputType.emailAddress, //klavyeye @ ekleme
                  onChanged: (val) {
                    //get the text whenever value changed
                    setState(() => email = val);
                  }),
              SizedBox(height: 20.0),
              TextFormField(
                  //username
                  decoration: InputDecoration(hintText: 'Kullanıcı adı'),
                  validator: (val) => //boşsa uyarı
                      val!.isEmpty ? 'Lütfen bir kullanıcı adı giriniz' : null,
                  onChanged: (val) {
                    //get the text whenever value changed
                    setState(() => username = val);
                  }),
              SizedBox(height: 20.0),
              TextFormField(
                  //password
                  decoration: InputDecoration(hintText: 'Şifre'),
                  validator: (val) => val!.length < 6 //kısaysa uyarı
                      ? 'Lütfen altı karakterden uzun bir şifre giriniz'
                      : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  }),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text("Üye ol"),
                onPressed: () async {
                  final valid = await usernameCheck(username);
                  if (!valid) {
                    //bu kullanıcı adı daha önce alındı. ekranda bir uyarı göster.
                  } else if (_formKey.currentState!.validate()) {
                    if (_formKey.currentState!.validate()) {
                      dynamic result = await _auth.regiterWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(
                            () => error = 'Lütfen geçerli bir eposta giriniz.');
                      }
                      addUserToDatabase(); //kullancı bilgilerini veritabanına yükle
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink[400],
                  textStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 12.0),
              Text(error, style: TextStyle(color: Colors.red, fontSize: 13.0)),
            ],
          ),
        ),
      ),
    );
  }
}
