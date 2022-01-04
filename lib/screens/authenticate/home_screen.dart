import '../../main.dart';
import 'package:flutter/material.dart';
import '../../image.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.person),
                  labelText: 'User Name',
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
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
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.password_outlined),
                  labelText: 'Password',
                ),
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
                  onPressed: () {
                    print(nameController.text);
                    print(passwordController.text);
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
