import 'package:first_unistaff_project/screens/authenticate/home_screen.dart';
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
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'User Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: nicknameController,
            decoration: const InputDecoration(
              labelText: 'Nick Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: universityController,
            decoration: const InputDecoration(
              labelText: 'University',
              border: OutlineInputBorder(),
            ),
          ),
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
                onPressed: () {
                  print(nameController.text);
                  print(passwordController.text);
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
                  ;
                },
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ]),
      ),
    );
  }
}
