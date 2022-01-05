import 'package:flutter/material.dart';
import 'menu.dart';
import 'package:first_unistaff_project/screens/profile/edit.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductDetail();
}

class _ProductDetail extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
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
              const SizedBox(
                height: 300,
                child: Product(),
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
                              'Product Name',
                              style:
                                  TextStyle(fontSize: 20.0, color: Colors.grey),
                            ),
                          ),
                          Container(
                            child: Text(
                              'Price',
                              style:
                                  TextStyle(fontSize: 15.0, color: Colors.grey),
                            ),
                          ),
                          Container(
                            child: Text(
                              'City',
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
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.purple.shade800,
                        radius: 30,
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          FlatButton(
                            textColor: Colors.lightGreenAccent,
                            child: const Text(
                              'User Name',
                              style: TextStyle(fontSize: 15),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SettingsUI())); //user account
                            },
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

class Product extends StatelessWidget {
  const Product({
    Key? key,
  }) : super(key: key);

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
            image: const DecorationImage(
              image: AssetImage('assets/images/foto.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
