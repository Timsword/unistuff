import 'package:flutter/material.dart';
import 'package:unistuff_main/models/stuff.dart';
import 'package:provider/provider.dart';
import 'package:unistuff_main/screens/home/stuff_grid.dart';

class StuffList extends StatefulWidget {
  const StuffList({Key? key}) : super(key: key);

  @override
  _StuffListState createState() => _StuffListState();
}

class _StuffListState extends State<StuffList> {
  @override
  Widget build(BuildContext context) {
    final stuffs = Provider.of<List<Stuff>?>(context);
    //print(stuffs?.docs);
    if (stuffs != null) {
      stuffs.forEach((stuff) {
        print(stuff.title);
        print(stuff.details);
        print(stuff.price);
      });
    }
    return ListView.builder(
      //listede bulunan eşyaların sayısı
      itemCount: stuffs!.length,
      //liste içindeki her eşya için geriye bir çeşit widget gönderecek func.
      itemBuilder: (context, index) {
        return StuffGrid(stuff: stuffs[index]);
      },
    );
  }
}
