import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_unistaff_project/screens/home/menu.dart';
import 'package:first_unistaff_project/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../settings.dart';
import 'edit.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userID = user!.uid;

    return ListView(children: [
      ProfilePic(),
      SizedBox(height: 20),
      Info(),
      Menu(
        text: "Profile Edit",
        press: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => EditProfilePage()));
        },
      ),
      Menu(
        text: "Settings",
        press: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SettingsPage()));
        },
      ),
      Menu(
        text: "Help Center",
        press: () {},
      ),
      Menu(
        text: "Log Out",
        press: () {},
      ),
    ]);
  }
}

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  var getImage = '';

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .get()
        .then((gelenVeri) {
      setState(() {
        getImage = gelenVeri.data()!['profileImage'];
      });
    });
    return SizedBox(
      height: 150,
      width: 150,
      child: CircleAvatar(
        backgroundImage: NetworkImage(getImage),
        radius: 50,
      ),
    );
  }
}

class Menu extends StatelessWidget {
  const Menu({
    Key? key,
    required this.press,
    required this.text,
  }) : super(key: key);

  final String text;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: press,
        child: Row(
          children: [
            Icon(Icons.circle),
            SizedBox(
              width: 30,
            ),
            Expanded(
                child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
            )),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  var getUserName = '';

  var getLocation = '';

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .get()
        .then((gelenVeri) {
      setState(() {
        getUserName = gelenVeri.data()!['username'];
        getLocation = gelenVeri.data()!['location'];
      });
    });
    return Center(
        child: Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(), //             <--- BoxDecoration here
          child: Text(
            getUserName,
            style: TextStyle(fontSize: 30.0),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(0.0),
          padding: const EdgeInsets.all(0.0),
          decoration: BoxDecoration(), //             <--- BoxDecoration here
          child: Text(
            getLocation,
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ],
    ));
  }
}
