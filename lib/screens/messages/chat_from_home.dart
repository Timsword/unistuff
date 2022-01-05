import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final docs; //ID of the user from the stuff

  const ChatPage({Key? key, this.docs}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? groupChatId;
  String? userID;

  TextEditingController textEditingController = TextEditingController();

  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    getGroupChatId(); //for creating a unique stuffID
    super.initState();
  }

  getGroupChatId() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userID = user!.uid;

    String anotherUserId = widget.docs['userID'];
    //if(userID == anotherUserId){} ??
    if (userID.compareTo(anotherUserId) > 0) {
      groupChatId = '$userID - $anotherUserId';
    } else {
      groupChatId = '$anotherUserId - $userID';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.docs['title']),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages') //pulling the messages from the database
            .doc(groupChatId)
            .collection(groupChatId!)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final FirebaseAuth auth = FirebaseAuth.instance;
            final User? user = auth.currentUser;
            final userID = user!.uid;
            return Column(
              children: <Widget>[
                Expanded(
                    child: ListView.builder(
                  //importing the message snapshots into a list
                  controller: scrollController,
                  itemBuilder: (listContext, index) => buildItem(
                      (snapshot.data! as QuerySnapshot).docs[index], userID),
                  itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                  reverse: true,
                )),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => sendMsg(),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Center(
                child: SizedBox(
              height: 36,
              width: 36,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ));
          }
        },
      ),
    );
  }

  sendMsg() {
    String msg = textEditingController.text.trim();

    /// Upload images to firebase and returns a URL
    ///COULD BE ADDED IN FUTURE UPDATES

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userID = user!.uid;

    if (msg.isNotEmpty) {
      print(
          'message on the way $msg'); //create a message with particular users informations.
      var ref = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId!)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(ref, {
          "senderId": userID,
          "anotherUserId": widget.docs['userID'],
          "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
          'content': msg,
          "type": 'text', //type of the message.
        });
        FirebaseFirestore.instance //sets userID's for reference.
            .collection('messages')
            .doc(groupChatId)
            .set({
          'senderID': userID,
          'anotherUserID': widget.docs['userID'],
          'lastMessage': msg,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        });
      });

      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    } else {
      //empty text
      print('Please enter some text to send');
    }
  }

  buildItem(doc, userID) {
    return Padding(
      //deisgn of chat
      padding: EdgeInsets.only(
          top: 8.0,
          left: ((doc['senderId'] == userID) ? 64 : 0),
          right: ((doc['senderId'] == userID) ? 0 : 64)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: ((doc['senderId'] == userID)
                ? Colors.grey
                : Colors.greenAccent),
            borderRadius: BorderRadius.circular(8.0)),
        child: Text('${doc['content']}'),
      ),
    );
  }
}
