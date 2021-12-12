import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unistuff_main/models/stuff.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference stuffCollection =
      FirebaseFirestore.instance.collection('stuffs');

  //ilan oluşturmak için veritabanı verisi title, details, price vb.
  Future updateUserStuff(String title, String details, int price) async {
    return await stuffCollection.doc(uid).set({
      'title': title,
      'details': details,
      'price': price,
    });
  }

//snapshot'dan çektiğimiz stufflist
  List<Stuff> _stuffListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Stuff(
          title: doc.get('title') ?? '',
          price: doc.get('price') ?? 0,
          details: doc.get('details') ?? '');
    }).toList();
  }

//ilanları getir - get the stuffs
  Stream<List<Stuff>> get stuffs {
    return stuffCollection.snapshots().map(_stuffListFromSnapshot);
  }
}
