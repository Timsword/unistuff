import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unistuff_main/screens/home/update_stuff_form.dart';

class profileSheet extends StatefulWidget {
  const profileSheet({Key? key}) : super(key: key);

  @override
  _profileSheetState createState() => _profileSheetState();
}

class _profileSheetState extends State<profileSheet> {
  final _formkey = GlobalKey<FormState>();

  //funcs

  @override
  Widget build(BuildContext context) {
    return Container(
      child: userStuffList(),
    );
  }
}

class userStuffList extends StatelessWidget {
  const userStuffList({Key? key}) : super(key: key);
  void _editStuff(BuildContext context) {
    //stuff_form link.
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: updateStuffForm());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userStuffList(),
    );
  }
}

class _userStuffList extends StatelessWidget {
  void _editStuff(BuildContext context) {
    //stuff_form'a yönlendirme.
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: updateStuffForm());
        });
  }

  /* _deleteStuff(BuildContext context) {
    //stuff_form'a yönlendirme.
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: updateStuffForm());
        });
  }*/

  deleteStuff(stuffID) {
    /*final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final _uid = user!.uid;*/
    FirebaseFirestore.instance.collection('Stuffs').doc(stuffID).delete();
  }

  markAsSold(stuffID) {
    FirebaseFirestore.instance.collection('Stuffs').doc(stuffID).update({
      'soldOrNot': 'sold',
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final _uid = user!.uid;
    Query _stuffStream = FirebaseFirestore.instance
        .collection('Stuffs')
        .where('userID', isEqualTo: _uid);

    return MaterialApp(
      home: StreamBuilder<QuerySnapshot>(
          //veri akışı başlatılıyor
          //akış oluşturuluyor
          stream: _stuffStream.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something is wrong.');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              //showing the data
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                String stuffID = data['stuffID'];
                return ListTile(
                  title: Text(data['title']),
                  subtitle: Column(
                    children: <Widget>[
                      Text(data['details']),
                      TextButton(
                          child: const Text('Düzenle'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => updateStuffForm(
                                        stuffID: data['stuffID'].toString())));
                            _editStuff(context);
                          }),
                      TextButton(
                          child: const Text('Sil'),
                          onPressed: () {
                            deleteStuff(stuffID);
                          }),
                      TextButton(
                          child: const Text('Satıldı olarak işaretle'),
                          onPressed: () {
                            markAsSold(stuffID);
                          })
                    ],
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
