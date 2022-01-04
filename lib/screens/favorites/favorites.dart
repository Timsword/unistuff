import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_unistaff_project/screens/messages/chat_from_home.dart';
import 'package:flutter/material.dart';

class ShoppingBasket extends StatefulWidget {
  const ShoppingBasket({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShoppingBasket();
}

class _ShoppingBasket extends State<ShoppingBasket>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                expandedHeight: 50,
                floating: true,
                pinned: true,
                snap: false,
                stretch: true,
                centerTitle: false,
                backgroundColor: Colors.lightBlue.shade800,
                bottom: const TabBar(
                  indicatorColor: Colors.lightGreenAccent,
                  indicator: UnderlineTabIndicator(
                    borderSide:
                        BorderSide(color: Colors.lightGreenAccent, width: 5.0),
                    insets: EdgeInsets.symmetric(horizontal: 40),
                  ),
                  labelColor: Colors.lightGreenAccent,
                  unselectedLabelColor: Colors.lightGreenAccent,
                  tabs: [
                    Tab(
                      iconMargin: EdgeInsets.only(top: 5),
                      text: "Favorites",
                    ),
                    Tab(
                      iconMargin: EdgeInsets.only(top: 5),
                      text: "Ads",
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              favorites(context),
              ads(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget favorites(BuildContext context) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final userID = user!.uid;

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

  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('favorites')
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
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('stuffs')
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
                                                docs: snap.data!.docs[index])));
                                  }),
                              TextButton.icon(
                                  icon: Icon(Icons.favorite),
                                  label: Text('Favori'),
                                  onPressed: () async {
                                    favorite(snap.data!.docs[index]['stuffID']);
                                  }),
                            ],
                          ),

                          /*SizedBox(
                    height: 10,
                  ),*/
                        );
                      }),
                ],
              );
            }),
      ]);
    },
  );
}

///////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
Widget ads() {
  return ListView(
    padding: const EdgeInsets.all(8),
    children: <Widget>[
      SizedBox(
        height: 10,
      ),
      Card(
        margin: EdgeInsets.all(10),
        elevation: 20,
        color: Colors.white54,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.lightGreenAccent,
            child: Icon(
              Icons.shopping_basket,
              color: Colors.white54,
            ),
            radius: 25,
          ),
          title: FlatButton(
            padding: EdgeInsets.fromLTRB(0, 0, 235, 0),
            child: const Text(
              'Product Name',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {},
          ),
          subtitle: Text("Ankara"),
          trailing: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Divider(
          color: Colors.grey,
          height: 20,
        ),
      ), //aralarına çizgi tanımlamak için
      //Divider widget'ını tanımlıyoruz
      Card(
        margin: EdgeInsets.all(10),
        elevation: 20,
        color: Colors.white54,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.lightGreenAccent,
            child: Icon(
              Icons.shopping_basket,
              color: Colors.white54,
            ),
            radius: 25,
          ),
          title: FlatButton(
            padding: EdgeInsets.fromLTRB(0, 0, 235, 0),
            child: const Text(
              'Product Name',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {},
          ),
          subtitle: Text("Aydın"),
          trailing: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Divider(
          color: Colors.grey,
          height: 20,
        ),
      ),
      Card(
        margin: EdgeInsets.all(10),
        elevation: 20,
        color: Colors.white54,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.lightGreenAccent,
            child: Icon(
              Icons.shopping_basket,
              color: Colors.white54,
            ),
            radius: 25,
          ),
          title: FlatButton(
            padding: EdgeInsets.fromLTRB(0, 0, 235, 0),
            child: const Text(
              'Product Name',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {},
          ),
          subtitle: Text("Antalya"),
          trailing: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Divider(
          color: Colors.grey,
          height: 20,
        ),
      ),
      Card(
        margin: EdgeInsets.all(10),
        elevation: 20,
        color: Colors.white54,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.lightGreenAccent,
            child: Icon(
              Icons.shopping_basket,
              color: Colors.white54,
            ),
            radius: 25,
          ),
          title: FlatButton(
            padding: EdgeInsets.fromLTRB(0, 0, 235, 0),
            child: const Text(
              'Product Name',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {},
          ),
          subtitle: Text("Trabzon"),
          trailing: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Divider(
          color: Colors.grey,
          height: 20,
        ),
      ),
    ],
  );
}
