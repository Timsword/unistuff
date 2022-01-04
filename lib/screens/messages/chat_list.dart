import 'package:first_unistaff_project/screens/messages/chat_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:first_unistaff_project/models/myuser.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    'Message',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  FlatButton(
                      child: Icon(CupertinoIcons.pencil), onPressed: () {}),
                ],
              ),
              SizedBox(height: 20),
              TextField(
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
              ),
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
                  time: '58min'),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget(
      {Key? key,
      required this.family,
      required this.msg,
      required this.time,
      this.count = 0})
      : super(key: key);

  final String family;
  final String msg;
  final String time;
  final int count;

  @override
  Widget build(BuildContext context) {
    var chat;
    return GestureDetector(
      /*onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChatPage(docs: data));
      ),*/
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
                  ),
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
                  '$family',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '$msg',
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey.shade700, height: 1.5),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '$time',
                style: TextStyle(
                    fontSize: 12,
                    color: count == 0 ? Colors.grey.shade500 : Colors.green),
              ),
              SizedBox(height: 10),
              this.count == 0
                  ? Container()
                  : CircleAvatar(
                      radius: 11,
                      backgroundColor: Colors.green.shade600,
                      child: Text(
                        '$count',
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
