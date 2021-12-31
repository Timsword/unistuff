import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:unistuff_main/screens/home/chat_page.dart';

class favoriteStuffList extends StatelessWidget {
  const favoriteStuffList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _favoriteStuffList(),
    );
  }
}

class _favoriteStuffList extends StatelessWidget {
  favorite(stuffID) async {
    Future<bool> checkIfDocExists(String docId) async {
      try {
        /// Check If Document Exists
        // Get reference to Firestore collection
        var collectionRef = FirebaseFirestore.instance.collection('favorites');

        var doc = await collectionRef.doc(docId).get();
        return doc.exists;
      } catch (e) {
        throw e;
      }
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userID = user!.uid;

    bool docExists = await checkIfDocExists(userID + "-" + stuffID);

    if (docExists == true) {
      //favorilerden çıkar
      FirebaseFirestore.instance
          .collection('favorites')
          .doc(userID + "-" + stuffID)
          .delete();
      FirebaseFirestore.instance //delete a favorite from stuff
          .collection('Stuffs')
          .doc(stuffID)
          .update({'favoriteNumber': FieldValue.increment(-1)});
    } else {
      //eğer favorilere eklemediyse eklemesini sağla
      FirebaseFirestore.instance
          .collection('favorites')
          .doc(userID + "-" + stuffID)
          .set({'userID': userID, 'stuffID': stuffID});
      FirebaseFirestore.instance //add a favorite to stuff
          .collection('Stuffs')
          .doc(stuffID)
          .update({'favoriteNumber': FieldValue.increment(1)});
    }
  }

  List<String> myFavoriteStuffs = [];
  Future<List<String>> getFavorites() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userID = user!.uid;
    var result = await FirebaseFirestore.instance
        .collection('favorites')
        .where("userID", whereIn: [userID]).get();
    for (var res in result.docs) {
      myFavoriteStuffs.add((res.data()['stuffID'] ?? ''));
    }

    return myFavoriteStuffs;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _stuffStream = FirebaseFirestore.instance
        .collection('Stuffs') //seçilen döküman
        .where('stuffID',
            isEqualTo:
                getFavorites()) //veriler yeniden eskiye şeklinde listeleniyor
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
                /*leading: CircleAvatar(
                  backgroundImage: AssetImage(
                      "https://www.kaspersky.com.tr/content/tr-tr/images/smb/icons/icon-ksos.png"), // no matter how big it is, it won't overflow
                ),*/
                /*leading: SizedBox(
                    height: 100.0,
                    width: 100.0, // fixed width and height
                    child: Image.asset(data['stuffImage'])),*/
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
                        favorite(data['stuffID']);
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
