import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../authenticate/log_in.dart';
import '../../image.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MenuState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final userID = user!.uid;

class _MenuState extends State<Menu> {
  favorite(stuffID) async {
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
    final Stream<QuerySnapshot> _stuffStream = FirebaseFirestore.instance
        .collection('Stuffs') //seçilen döküman
        .orderBy('dateTime',
            descending: true) //veriler yeniden eskiye şeklinde listeleniyor
        .snapshots();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.purple.shade800,
            floating: true,
            pinned: true,
            snap: false,
            stretch: true,
            centerTitle: false,
            expandedHeight: 65,
            bottom: AppBar(
              backgroundColor: Colors.purple.shade800,
              title: Container(
                width: double.infinity,
                height: 45,
                color: Colors.white,
                child: Center(
                  child: TextField(
                    cursorColor: Colors.purple.shade800,
                    decoration: InputDecoration(
                      fillColor: Colors.purple.shade800,
                      hintText: 'Search for something',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                height: 400,
                child: Center(
                  child: _ContentGridView(),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

Widget GridContent() {
  TextEditingController nameController = TextEditingController();
  String productName;
  return ListView(children: [
    Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 25),
      alignment: Alignment.topCenter,
      child: Container(
        height: 150,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(20.0),
          image: const DecorationImage(
            image: AssetImage('assets/images/foto.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
    Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          alignment: Alignment.bottomRight,
          child: IconButton(
            iconSize: 20,
            icon: Icon(Icons.favorite),
            onPressed: () {},
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
          alignment: Alignment.bottomLeft,
          child: TextButton(
            onPressed: () {},
            onLongPress: () {},
            child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.grey,
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {},
              child: Text("Product Name"),
            ),
          ),
        ),
      ],
    ),
    Column(
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          child: Text("price"),
        )
      ],
    ),
  ]);
}

Widget _ContentGridView() {
  final Stream<QuerySnapshot> _stuffStream = FirebaseFirestore.instance
      .collection('stuffs') //seçilen döküman
      .orderBy('dateTime',
          descending: true) //veriler yeniden eskiye şeklinde listeleniyor
      .snapshots();
  return StreamBuilder<QuerySnapshot>(
      stream: _stuffStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Bir hata oluştu, tekrar deneyiniz.');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Yükleniyor");
        }
        if (!snapshot.hasData) {
          return Text('error');
        }
        if (snapshot.hasData) {
          return Text('bekle hocam');
        }
        if (snapshot.hasData) {
          return ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children:
                  snapshot.data!.docs.map<Widget>((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                print(data['title']);
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) => Card(
                          child: GridTile(
                            child: Center(
                              child: GridContent(),
                            ),
                          ),
                        ));
              }).toList());
        } else {
          return const CircularProgressIndicator();
        }
      });
}
