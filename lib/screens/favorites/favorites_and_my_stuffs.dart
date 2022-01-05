import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_unistaff_project/screens/favorites/update_stuff_form.dart';
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
        length: 3,
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
                      text: "My stuffs",
                    ),
                    Tab(
                      iconMargin: EdgeInsets.only(top: 5),
                      text: "My solded stuffs",
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              favorites(context),
              MyStuffs(context),
              MySoldedStuffs(context),
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
    String a;
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
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('stuffs')
                          .where('stuffID',
                              isEqualTo: snapshot.data!.docs[index]
                                  ['stuffID']) //seçilen döküman
                          .snapshots(),
                      builder: (context, snap) {
                        print(snap.data!.docs[index]['stuffImage']);
                        if (!snap.hasData)
                          return const CircularProgressIndicator();
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
/////////////////////////////    mystuffs     ////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
Widget MyStuffs(BuildContext context) {
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

  deleteStuff(stuffID) {
    /*final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final _uid = user!.uid;*/
    FirebaseFirestore.instance.collection('stuffs').doc(stuffID).delete();
  }

  markAsSold(stuffID) {
    FirebaseFirestore.instance.collection('stuffs').doc(stuffID).update({
      'soldOrNot': 'sold',
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final _uid = user!.uid;
  Query _stuffStream = FirebaseFirestore.instance
      .collection('stuffs')
      .where('userID', isEqualTo: _uid)
      .where('soldOrNot', isEqualTo: 'in sale');
  return MaterialApp(
    home: StreamBuilder<QuerySnapshot>(
        //veri akışı başlatılıyor
        //akış oluşturuluyor
        stream: _stuffStream.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something is wrong.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView(
            //showing the data
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              String stuffID = data['stuffID'];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(data['stuffImage']),
                ),
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

Widget MySoldedStuffs(BuildContext context) {
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

  deleteStuff(stuffID) {
    /*final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final _uid = user!.uid;*/
    FirebaseFirestore.instance.collection('stuffs').doc(stuffID).delete();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final _uid = user!.uid;
  Query _stuffStream = FirebaseFirestore.instance
      .collection('stuffs')
      .where('userID', isEqualTo: _uid)
      .where('soldOrNot', isEqualTo: 'sold');
  return MaterialApp(
    home: StreamBuilder<QuerySnapshot>(
        //veri akışı başlatılıyor
        //akış oluşturuluyor
        stream: _stuffStream.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something is wrong.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView(
            //showing the data
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              String stuffID = data['stuffID'];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(data['stuffImage']),
                ),
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
                  ],
                ),
              );
            }).toList(),
          );
        }),
  );
}
