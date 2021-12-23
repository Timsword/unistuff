import 'package:cloud_firestore/cloud_firestore.dart';
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
  String name = '';
  String username = '';
  String password = '';
  String error = '';
  String usernameError = 'false';
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  addUserToDatabase() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .set({'email': email, 'name': name, 'username': username});
  }

  checkUsername() async {
    //kullanıcı adının daha önceden alınıp alınmadığını kontrol etme
    ////////////////////////çalışmıyor
    //string _username with the userName of each user.
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    //converts results to a list of documents
    final List<DocumentSnapshot> documents = result.docs;

    //checks the length of the document to see if its
    //greater than 0 which means the username has already been taken the name
    if (documents.length > 0) {
      print(username + ' adının bir sahibi var!');
      return false;
    } else {
      print(username + ' are you sure you want to use this name');
      return true;
    }
  }

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
                  validator: (val) => //boşsa uyarı
                      val!.isEmpty ? 'Lütfen bir eposta giriniz' : null,
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
                  validator: (val) => val!.length < 6 //boşsa uyarı
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
                  if (checkUsername == false) {
                    //kullanıcı adının daha önceden alınıp alınmadığını kontrol etme
                    setState(////////////////////çalışmıyor
                        () => error = username + ' adının bir sahibi var!');
                    print("epik");
                    return;
                  }

                  addUserToDatabase(); //kullancı bilgilerini veritabanına yükle
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
