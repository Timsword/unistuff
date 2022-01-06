import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_unistaff_project/screens/messages/chat_from_deails.dart';
import 'package:flutter/material.dart';
import 'menu.dart';
import 'package:first_unistaff_project/screens/profile/edit.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({Key? key, this.stuffID}) : super(key: key);
  final String? stuffID;

  @override
  State<StatefulWidget> createState() => _ProductDetail();
}

class _ProductDetail extends State<ProductDetail> {
  String getTitle = '';
  String getLocation = '';
  String getPrice = '';
  String getImage = '';
  String getUniversity = '';
  String getProfileImage = '';
  String getUserName = '';
  String getSellerUserID = '';
  String getUserImage = '';
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('stuffs')
        .doc(widget.stuffID)
        .get()
        .then((gelenVeri) {
      setState(() {
        getTitle = gelenVeri.data()!['title'];
        getPrice = gelenVeri.data()!['price'];
        getImage = gelenVeri.data()!['stuffImage'];
      });
    });
    FirebaseFirestore.instance
        .collection('stuffs')
        .doc(widget.stuffID)
        .get()
        .then((incomingData) {
      var sellerUserID = incomingData.data()!['userID'];
      setState(() {
        getSellerUserID = sellerUserID;
      });

      FirebaseFirestore.instance
          .collection('users')
          .doc(sellerUserID)
          .get()
          .then((incomingData) {
        setState(() {
          getUserName = incomingData.data()!['username'];
          getProfileImage = incomingData.data()!['profileImage'];
          getUniversity = incomingData.data()!['university'];
          getLocation = incomingData.data()!['location'];
          getUserImage = incomingData.data()!['profileImage'];
        });
      });
    });
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 60,
            floating: true,
            pinned: true,
            snap: false,
            stretch: true,
            centerTitle: false,
            backgroundColor: Colors.white54,
            bottom: AppBar(
              title: const Text('Product Detail'),
              titleTextStyle:
                  const TextStyle(fontSize: 30.0, color: Colors.white),
              elevation: 40,
              backgroundColor: Colors.white54,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const MainPage()));
                },
                icon: const Icon(Icons.arrow_back_ios_new),
                color: Colors.white,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 300,
                child: Product(image: getImage),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Container(
                    height: 95,
                    width: 100,
                    padding: const EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.lightGreenAccent, width: 2),
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Container(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              getTitle,
                              style:
                                  TextStyle(fontSize: 20.0, color: Colors.grey),
                            ),
                          ),
                          Container(
                            child: Text(
                              getPrice + " TL",
                              style:
                                  TextStyle(fontSize: 15.0, color: Colors.grey),
                            ),
                          ),
                          Container(
                            child: Text(
                              getLocation,
                              style:
                                  TextStyle(fontSize: 15.0, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 200),
                child: Container(
                  height: 90,
                  width: 100,
                  padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.lightGreenAccent, width: 2),
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.purple.shade800,
                        radius: 30,
                        backgroundImage: (NetworkImage(getUserImage)),
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              FlatButton(
                                textColor: Colors.lightGreenAccent,
                                child: Text(
                                  getUserName,
                                  style: TextStyle(fontSize: 15),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SettingsUI())); //user account
                                },
                              ),
                              TextButton(
                                  child: Text('message'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                                sellerUserID: getSellerUserID,
                                                title: getTitle)));
                                  }),
                            ],
                          ),
                          Text(
                            getUniversity,
                            style: TextStyle(
                                fontSize: 15, color: Colors.lightGreenAccent),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class Product extends StatefulWidget {
  Product({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 300,
          width: 450,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            image: DecorationImage(
              image: NetworkImage(widget.image),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
