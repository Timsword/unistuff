import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_unistaff_project/models/loading.dart';
import 'package:first_unistaff_project/screens/messages/chat_from_deails.dart';
import 'package:first_unistaff_project/screens/messages/chat_from_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:first_unistaff_project/models/myuser.dart';

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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData) {
          return Text("data yok ustaa");
        }
        return Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Messages',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              /*FlatButton(//send new message button
                      child: Icon(CupertinoIcons.pencil), onPressed: () {}),*/
            ],
          ),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                print('another user id:');
                print(snapshot.data!.docs[index]['anotherUserID']);
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
                          if (!snap.hasData) return circularProgress();
                          print(snap.data!.docs[index]['profileImage']);
                          print(snap.data!.docs[index]['name']);
                          print(snap.data!.docs[index]['username']);
                          print(snapshot.data!.docs[index]['lastMessage']);
                          print(snapshot.data!.docs[index]['timestamp']);

                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChatPageFromContatcs(
                                              docs: snap.data!.docs[index])));
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snap.data!.docs[index]['profileImage']),
                            ),
                            title: Text(snap.data!.docs[index]['username']),
                            subtitle: Column(
                              children: <Widget>[
                                Text(snapshot.data!.docs[index]['lastMessage']),
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Messages',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  /*FlatButton(//send new message button
                      child: Icon(CupertinoIcons.pencil), onPressed: () {}),*/
                ],
              ),
              SizedBox(height: 20),
              /*TextFormField(
                //search person button
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(27.0),
                    gapPadding: 4,
                  ),
                  fillColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.grey[500]),
                  labelText: 'Search',
                  prefixIcon:
                      Icon(Icons.search, color: Colors.grey[500], size: 25.0),
                ),
              ),*/

              /*
              MessageWidget(
                  family: 'Zeynep',
                  msg: 'Hello whats up?',
                  time: '23min',
                  count: 1),
              MessageWidget(
                  family: 'Aycan',
                  msg: 'Hey,what is the price?',
                  time: '43min'),
              MessageWidget(
                  family: 'Mehmet', msg: 'where are you guys?', time: '56min'),
              MessageWidget(
                  family: 'Nazli',
                  msg: 'give me back im wating',
                  time: '58min'),*/
            ],
          ),
        ),
      ),
    );
  }
}

class MessageWidget extends StatefulWidget {
  final data;
  const MessageWidget(
      {Key? key,
      required this.family,
      required this.msg,
      required this.time,
      required this.image,
      required this.data,
      this.count = 0})
      : super(key: key);

  final String family;
  final String msg;
  final String time;
  final int count;
  final String image;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    var chat;
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatPageFromContatcs(docs: widget.data))),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3),
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(45),
            ),
            child: Container(
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(45),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.image),
                    ),
                  ),
                  /*child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 45.0,
                        backgroundImage: NetworkImage(widget.image),
                      )
                    ],
                  ),*/
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.family}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '${widget.msg}',
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey.shade700, height: 1.5),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '${widget.time}',
                style: TextStyle(
                    fontSize: 12,
                    color: widget.count == 0
                        ? Colors.grey.shade500
                        : Colors.green),
              ),
              SizedBox(height: 10),
              this.widget.count == 0
                  ? Container()
                  : CircleAvatar(
                      radius: 11,
                      backgroundColor: Colors.green.shade600,
                      child: Text(
                        '${widget.count}',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
            ],
          ),
        ],
      ),
    );
  }
}
