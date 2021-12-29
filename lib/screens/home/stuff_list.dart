import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:unistuff_main/screens/home/chat_page.dart';

class StuffList extends StatelessWidget {
  const StuffList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _stuffList(),
    );
  }
}

class _stuffList extends StatelessWidget {
  favorite(stuffID) {
    //GAYET İYİ ÇALIŞIYOR TEK SIKINTISI COLLECTION BOŞSA İF ELSE KOŞULUNA SOKMAN LAZIM
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userID = user!.uid;
    if (FirebaseFirestore.instance
            .collection('favorites')
            .doc(userID + "-" + stuffID) ==
        null) {
      //eğer favorilere eklemediyse eklemesini sağla
      FirebaseFirestore.instance
          .collection('favorites')
          .doc(userID + "-" + stuffID)
          .delete();
    } else {
      //favorilerden çıkar
      FirebaseFirestore.instance
          .collection('favorites')
          .doc(userID + "-" + stuffID)
          .set({'userID': userID, 'stuffID': stuffID});
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _stuffStream = FirebaseFirestore.instance
        .collection('Stuffs') //seçilen döküman
        .orderBy('dateTime',
            descending: true) //veriler yeniden eskiye şeklinde listeleniyor
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
        //veri akışı başlatılıyor
        //akış oluşturuluyor
        stream: _stuffStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Bir hata oluştu, tekrar deneyiniz.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Yükleniyor");
          }

          return ListView(
            //veriyi gösterme kısmı
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title']),
                subtitle: Column(
                  children: <Widget>[
                    Text(data['details']),
                    TextButton(
                        child: const Text('Mesaj'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPage(docs: data)));
                        }),
                    TextButton.icon(
                      icon: Icon(Icons.favorite),
                      label: Text('Favori'),
                      onPressed: () async {
                        //favorite(data['stuffID']);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        });
  }
}
