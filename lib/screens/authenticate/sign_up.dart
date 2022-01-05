import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_unistaff_project/screens/authenticate/log_in.dart';
import 'package:first_unistaff_project/services/auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController universityController = TextEditingController();

  //text field states
  String email = '';
  String name = '';
  String username = '';
  String password = '';
  String location = '';
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
      'university': university,
      'location': location
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios_new),
        title: const Text('Sign Up'),
        backgroundColor: Colors.white54,
        titleTextStyle: const TextStyle(fontSize: 30.0, color: Colors.white),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(children: [
            SizedBox(
              height: 175,
              width: 175,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.purple.shade800,
                  ),
                  Positioned(
                    bottom: 10,
                    right: 80,
                    child: RawMaterialButton(
                      onPressed: () {},
                      elevation: 5.0,
                      fillColor: Colors.red,
                      child: const Icon(Icons.camera_alt_outlined),
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => //boşsa uyarı
                    val!.isEmpty ? 'Please insert a name' : null,
                onChanged: (val) {
                  //get the text whenever value changed
                  setState(() => name = val);
                }),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => //boşsa uyarı
                    val!.isEmpty ? 'Please insert a nickname' : null,
                onChanged: (val) {
                  //get the text whenever value changed
                  setState(() => username = val);
                }),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
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
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.length < 6 //kısaysa uyarı
                    ? 'Lütfen altı karakterden uzun bir şifre giriniz'
                    : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                }),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: universityController,
                decoration: const InputDecoration(
                  labelText: 'University',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => //boşsa uyarı
                    val!.isEmpty ? 'Lütfen bir üniversite giriniz' : null,
                onChanged: (val) {
                  //get the text whenever value changed
                  setState(() => university = val);
                }),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => //boşsa uyarı
                    val!.isEmpty ? 'Lütfen bir isim giriniz' : null,
                onChanged: (val) {
                  //get the text whenever value changed
                  setState(() => name = val);
                }),
            const SizedBox(
              height: 10,
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.purple.shade800,
                  child: const Text('Sign Up'),
                  onPressed: () async {
                    final valid = await usernameCheck(username);
                    if (!valid) {
                      ////////////////////////
                      //bu kullanıcı adı daha önce alındı. ekranda bir uyarı göster.
                      ///////////////////////
                    } else if (_formKey.currentState!.validate()) {
                      if (_formKey.currentState!.validate()) {
                        print(email);
                        dynamic result =
                            await _auth.regiterWithEmailAndPassword(
                                email.trim(), password);
                        if (result == null) {
                          setState(() =>
                              error = 'Lütfen geçerli bir eposta giriniz.');
                        }
                        addUserToDatabase(); //kullancı bilgilerini veritabanına yükle
                      }
                    }
                  },
                )),
            Row(
              children: <Widget>[
                const Text('Already have account?'),
                FlatButton(
                  textColor: Colors.lightGreenAccent,
                  child: const Text(
                    'Log in',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            SizedBox(height: 12.0),
            Text(error, style: TextStyle(color: Colors.red, fontSize: 13.0)),
          ]),
        ),
      ),
    );
  }
}
