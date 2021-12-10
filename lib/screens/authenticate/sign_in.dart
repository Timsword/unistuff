import 'package:flutter/material.dart';
import 'package:unistuff_main/services/auth.dart';

class SignIn extends StatefulWidget {
  //const SignIn({Key? key}) : super(key: key);
  final Function toggleView;
  SignIn({required this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //text field states
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Giriş yap'),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Üye ol'),
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
                  //e-mail
                  validator: (val) =>
                      val!.isEmpty ? 'Lütfen bir eposta giriniz' : null,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) {
                    //get the text whenever value changed
                    setState(() => email = val);
                  }),
              SizedBox(height: 20.0),
              TextFormField(
                  validator: (val) => val!.length < 6
                      ? 'Lütfen altı karakterden uzun bir şifre giriniz'
                      : null,
                  //password
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  }),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text("Giriş yap"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic result =
                        await _auth.signInWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() => error = 'Giriş başarısız oldu.');
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
