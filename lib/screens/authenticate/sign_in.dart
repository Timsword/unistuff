import 'package:flutter/material.dart';
import 'package:unistuff_main/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Giriş yap'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: ElevatedButton(
          child: Text('Öğrenci e-postan ile giriş yap'),
          onPressed: () async {
            dynamic result = await _auth.signInWithMail();
            if (result == null) {
              print('Giriş hatası');
            } else {
              print('Giriş yapıldı');
              print(result);
            }
          },
        ),
      ),
    );
  }
}
