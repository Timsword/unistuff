import 'package:first_unistaff_project/services/auth.dart';

import '../../main.dart';
import 'package:flutter/material.dart';
import '../../image.dart';
import 'sign_up.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //text field states
  String email = '';
  String username = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            SizedBox(
                height: 150,
                child: ImageBanner("../assets/images/unistuff_logo.png")),
            SizedBox(
              height: 50.0,
            ),
            Container(
              height: 60.0,
              width: 300.0,
              decoration: new BoxDecoration(
                color: Colors.white60,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(50.0),
                  topRight: const Radius.circular(50.0),
                  bottomLeft: const Radius.circular(50.0),
                  bottomRight: const Radius.circular(50.0),
                ),
              ),
              child: TextFormField(
                  //email o username
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.person),
                    labelText: 'Username or email',
                  ),
                  validator: (val) =>
                      val!.isEmpty ? 'Lütfen bir eposta giriniz' : null,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) {
                    //get the text whenever value changed
                    if (val.contains('@')) {
                      setState(() => email = val);
                    } else {
                      setState(() => username = val);
                    }
                  }),
            ),
            SizedBox(
              height: 30.0,
            ),
            Form(
              key: _formKey,
              child: Container(
                width: 300.0,
                height: 60.0,
                decoration: new BoxDecoration(
                  color: Colors.white60,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(50.0),
                    topRight: const Radius.circular(50.0),
                    bottomLeft: const Radius.circular(50.0),
                    bottomRight: const Radius.circular(50.0),
                  ),
                ),
                child: TextFormField(
                    //password
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.password_outlined),
                      labelText: 'Password',
                    ),
                    validator: (val) => val!.length < 6
                        ? 'Lütfen altı karakterden uzun bir şifre giriniz'
                        : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    }),
              ),
            ),
            FlatButton(
              onPressed: () {
                //forgot password screen
              },
              textColor: Colors.lightGreenAccent,
              child: const Text('Forgot Password'),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.purple.shade800,
                  child: Text('Login'),
                  onPressed: () async {
                    print(email);
                    print(username);
                    print(password);
                    if (_formKey.currentState!.validate()) {
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() => error = 'Giriş başarısız oldu.');
                      }
                    }
                  },
                )),
            Row(
              children: <Widget>[
                Text('Does not have account?'),
                FlatButton(
                  textColor: Colors.lightGreenAccent,
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )
          ],
        ),
      ),
    );
  }
}
