import 'package:flutter/material.dart';
import 'screens/authenticate/home_screen.dart';
import 'image.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
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
  return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) => Card(
            child: GridTile(
              child: Center(
                child: GridContent(),
              ),
            ),
          ));
}
