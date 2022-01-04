import 'package:flutter/material.dart';

class ShoppingBasket extends StatefulWidget {
  const ShoppingBasket({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _ShoppingBasket();

}

class _ShoppingBasket extends State<ShoppingBasket> with TickerProviderStateMixin {
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
                backgroundColor: Colors.purple.shade800,
                bottom: const TabBar(
                  indicatorColor: Colors.lightGreenAccent,
                  indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.lightGreenAccent, width: 5.0),
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
              favorites(),
              ads(),
            ],
          ),
        ),
      ),
    );
  }
}

  Widget favorites(){
      return ListView(
        padding: const EdgeInsets.all(8),
      children:  <Widget>[
        SizedBox(height: 10,),        
            Card(
              margin: EdgeInsets.all(10),
              elevation:20,
              color: Colors.white54,
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.lightGreenAccent ,child: Icon(Icons.shopping_basket,color: Colors.white54,),radius: 25,),
                title: FlatButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 235, 0),
                                child: const Text(
                                  'Product Name',
                                  style: TextStyle(fontSize: 16),
                                ),
                                onPressed: () {},
                            ),
                subtitle: Text("Ankara"),
                trailing: Icon(Icons.favorite, color: Colors.red,),
              ),
            ), 
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(color: Colors.grey, height: 20,),
          ), //aralarına çizgi tanımlamak için
          //Divider widget'ını tanımlıyoruz
            Card(
              margin: EdgeInsets.all(10),
              elevation:20,
              color: Colors.white54,
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.lightGreenAccent ,child: Icon(Icons.shopping_basket,color: Colors.white54,),radius: 25,),
                 title: FlatButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 235, 0),
                                child: const Text(
                                  'Product Name',
                                  style: TextStyle(fontSize: 16),
                                ),
                                onPressed: () {},
                            ),
                subtitle: Text("Aydın"),
                trailing: Icon(Icons.favorite, color: Colors.red,),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(color: Colors.grey, height: 20,),
          ),
            Card(
              margin: EdgeInsets.all(10),
              elevation:20,
              color: Colors.white54,
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.lightGreenAccent ,child: Icon(Icons.shopping_basket,color: Colors.white54,),radius: 25,),
                title: FlatButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 235, 0),
                                child: const Text(
                                  'Product Name',
                                  style: TextStyle(fontSize: 16),
                                ),
                                onPressed: () {},
                            ),
                subtitle: Text("Antalya"),
                trailing: Icon(Icons.favorite, color: Colors.red,), 
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(color: Colors.grey, height: 20,),
          ),
                      Card(
              margin: EdgeInsets.all(10),
              elevation:20,
              color: Colors.white54,
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.lightGreenAccent ,child: Icon(Icons.shopping_basket,color: Colors.white54,),radius: 25,),
                title: FlatButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 235, 0),
                                child: const Text(
                                  'Product Name',
                                  style: TextStyle(fontSize: 16),
                                ),
                                onPressed: () {},
                            ),
                subtitle: Text("Trabzon"),
                trailing: Icon(Icons.favorite, color: Colors.red,),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(color: Colors.grey, height: 20,),
          ),
      ],
  );
}

  Widget ads(){
      return ListView(
        padding: const EdgeInsets.all(8),
      children:  <Widget>[
        SizedBox(height: 10,),        
            Card(
              margin: EdgeInsets.all(10),
              elevation:20,
              color: Colors.white54,
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.lightGreenAccent ,child: Icon(Icons.shopping_basket,color: Colors.white54,),radius: 25,),
                title: FlatButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 235, 0),
                                child: const Text(
                                  'Product Name',
                                  style: TextStyle(fontSize: 16),
                                ),
                                onPressed: () {},
                            ),
                subtitle: Text("Ankara"),
                trailing: Icon(Icons.favorite, color: Colors.red,),
              ),
            ), 
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(color: Colors.grey, height: 20,),
          ), //aralarına çizgi tanımlamak için
          //Divider widget'ını tanımlıyoruz
            Card(
              margin: EdgeInsets.all(10),
              elevation:20,
              color: Colors.white54,
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.lightGreenAccent ,child: Icon(Icons.shopping_basket,color: Colors.white54,),radius: 25,),
                 title: FlatButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 235, 0),
                                child: const Text(
                                  'Product Name',
                                  style: TextStyle(fontSize: 16),
                                ),
                                onPressed: () {},
                            ),
                subtitle: Text("Aydın"),
                trailing: Icon(Icons.favorite, color: Colors.red,),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(color: Colors.grey, height: 20,),
          ),
            Card(
              margin: EdgeInsets.all(10),
              elevation:20,
              color: Colors.white54,
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.lightGreenAccent ,child: Icon(Icons.shopping_basket,color: Colors.white54,),radius: 25,),
                title: FlatButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 235, 0),
                                child: const Text(
                                  'Product Name',
                                  style: TextStyle(fontSize: 16),
                                ),
                                onPressed: () {},
                            ),
                subtitle: Text("Antalya"),
                trailing: Icon(Icons.favorite, color: Colors.red,), 
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(color: Colors.grey, height: 20,),
          ),
                      Card(
              margin: EdgeInsets.all(10),
              elevation:20,
              color: Colors.white54,
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.lightGreenAccent ,child: Icon(Icons.shopping_basket,color: Colors.white54,),radius: 25,),
                title: FlatButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 235, 0),
                                child: const Text(
                                  'Product Name',
                                  style: TextStyle(fontSize: 16),
                                ),
                                onPressed: () {},
                            ),
                subtitle: Text("Trabzon"),
                trailing: Icon(Icons.favorite, color: Colors.red,),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(color: Colors.grey, height: 20,),
          ),
      ],
  );
}