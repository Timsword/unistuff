import 'package:flutter/material.dart';
import 'package:unistuff_main/models/stuff.dart';

class StuffTile extends StatelessWidget {
  //const StuffGrid({ Key? key }) : super(key: key);

  //stufflist'den gelen veriyi stuff'a atıyoruz
  final Stuff? stuff;
  StuffTile({this.stuff});

  @override
  Widget build(BuildContext context) {
    //ürünlerin liste görünümü oluşturuluyor
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.brown,
              ),
              title: Text(stuff!.title),
              subtitle: Text(stuff!.details)

              /*Column(
              children: <Widget>[
                Text('Title2'),
                Text('Title 3'),
                Text('Title 4'),
                Text('and so on')
              ],
            ),*/
              ),
        ));
  }
}
