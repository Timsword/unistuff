import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unistuff_main/screens/home/chat_page.dart';

class favorite_list extends StatelessWidget {
  favorite(stuffID) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userID = user!.uid;
    Future<bool> checkIfDocExists(String stuffID) async {
      try {
        /// Check If Document Exists
        // Get reference to Firestore collection
        var collectionRef = FirebaseFirestore.instance
            .collection('favorites')
            .doc(userID)
            .collection(userID);

        var doc = await collectionRef.doc(stuffID).get();
        return doc.exists;
      } catch (e) {
        throw e;
      }
    }

    bool docExists = await checkIfDocExists(stuffID);

    if (docExists == true) {
      //eğer zaten favorilemişse favorilerden çıkar
      FirebaseFirestore.instance
          .collection('favorites')
          .doc(userID)
          .collection(userID)
          .doc(stuffID)
          .delete();
      FirebaseFirestore.instance //delete a favorite from stuff
          .collection('Stuffs')
          .doc(stuffID)
          .update({'favoriteNumber': FieldValue.increment(-1)});
    } else {
      //eğer favorilere eklemediyse eklemesini sağla
      String _dateTime = DateTime.now().toString();
      FirebaseFirestore.instance
          .collection('favorites')
          .doc(userID)
          .collection(userID)
          .doc(stuffID)
          .set({'stuffID': stuffID, 'dateTime': _dateTime});
      FirebaseFirestore.instance //add a favorite to stuff
          .collection('Stuffs')
          .doc(stuffID)
          .update({'favoriteNumber': FieldValue.increment(1)});
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userID = user!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .doc(userID)
          .collection(userID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text("Loadsing...");
        return Column(children: [
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                //return buildListItem(context, snapshot.data.documents[index]);
                return ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Stuffs')
                            .where('stuffID',
                                isEqualTo: snapshot.data!.docs[index]
                                    ['stuffID']) //seçilen döküman
                            .snapshots(),
                        builder: (context, snap) {
                          if (!snap.hasData) return const Text("Loading...d");
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snap.data!.docs[index]['stuffImage']),
                            ),
                            /*leading: SizedBox(
                    height: 100.0,
                    width: 100.0, // fixed width and height
                    child: Image.asset(data['stuffImage'])),*/
                            title: Text(snap.data!.docs[index]['title']),
                            subtitle: Column(
                              children: <Widget>[
                                Text(snap.data!.docs[index]['details']),
                                TextButton(
                                    child: const Text('Mesaj'),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChatPage(
                                                  docs:
                                                      snap.data!.docs[index])));
                                    }),
                                TextButton.icon(
                                    icon: Icon(Icons.favorite),
                                    label: Text('Favori'),
                                    onPressed: () async {
                                      favorite(
                                          snap.data!.docs[index]['stuffID']);
                                    }),
                              ],
                            ),
                          );
                        }),
                  ],
                );
              }),
        ]);
      },
    );
  }
}
