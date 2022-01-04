import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unistuff_main/screens/home/chat_page.dart';
import 'package:unistuff_main/screens/home/chat_page_contatcs.dart';

class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userID = user!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .where('senderID', isEqualTo: userID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text("Loading...");
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
                            .collection('users')
                            .where('userID',
                                isEqualTo: snapshot.data!.docs[index]
                                    ['anotherUserID'])
                            .snapshots(),
                        builder: (context, snap) {
                          if (!snap.hasData) return const Text("Loading...d");
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snap.data!.docs[index]['profileImage']),
                            ),
                            title: Text(snap.data!.docs[index]['name']),
                            subtitle: Column(
                              children: <Widget>[
                                Text(snap.data!.docs[index]['username']),
                                Text(snapshot.data!.docs[index]['lastMessage']),
                                Text(snapshot.data!.docs[index]['timestamp']),
                                TextButton(
                                    child: const Text('message'),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatPageFromContatcs(
                                                      docs: snap
                                                          .data!.docs[index])));
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
