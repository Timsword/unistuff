import 'package:flutter/material.dart';
import 'package:unistuff_main/services/auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //text field states
  String email = '';
  String password = '';
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Unistuff\'a katıl!'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(//e-mail
                  onChanged: (val) {
                //get the text whenever value changed
                setState(() => email = val);
              }),
              SizedBox(height: 20.0),
              TextFormField(
                  //password
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  }),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text("Üye ol"),
                onPressed: () async {
                  print(email);
                  print(password);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink[400],
                  textStyle: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
