import 'package:flutter/material.dart';
import 'package:unistuff_main/services/auth.dart';

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
  String password = '';
  String error = '';
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

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

                  //e-mail
                  validator: (val) =>
                      val!.isEmpty ? 'Lütfen bir eposta giriniz' : null,
                  onChanged: (val) {
                    //get the text whenever value changed
                    setState(() => email = val);
                  }),
              SizedBox(height: 20.0),
              TextFormField(
                  //password
                  validator: (val) => val!.length < 6
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
                  if (_formKey.currentState!.validate()) {
                    dynamic result = await _auth.regiterWithEmailAndPassword(
                        email, password);
                    if (result == null) {
                      setState(
                          () => error = 'Lütfen geçerli bir eposta giriniz.');
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
