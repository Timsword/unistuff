import 'package:flutter/material.dart';
import 'screens/authenticate/home_screen.dart';
import 'image.dart';
import 'screens/authenticate/signup.dart';
import 'edit.dart';
import 'menu.dart';
import 'shopping_basket.dart';

class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  final _icerikler = [
    //Kategori(kategori: ,),
    const Login(),
    Menu(),
    ShoppingBasket(),
    EditProfilePage(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('UniStaff'),
        ),
        body: Center(
          child: _icerikler[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              backgroundColor: Colors.white60,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text('Message'),
              backgroundColor: Colors.white60,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart),
              title: Text('Shopping'),
              backgroundColor: Colors.white60,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
              backgroundColor: Colors.white60,
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTap,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {},
          backgroundColor: Colors.white54,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
