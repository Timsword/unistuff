import 'package:first_unistaff_project/screens/add_stuff_form.dart';
import 'package:first_unistaff_project/screens/messages/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/myuser.dart';
import 'authenticate/log_in.dart';
import '../image.dart';
import 'authenticate/sign_up.dart';
import 'profile/edit.dart';
import 'profile/profile.dart';
import 'home/menu.dart';
import 'favorites/favorites_and_my_stuffs.dart';

class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  final _icerikler = [
    //Kategori(kategori: ,),
    MainPage(),
    ChatList(),
    ShoppingBasket(),
    ProfilePage(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addStuff(BuildContext context) {
    //stuff_form'a yönlendirme.
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: AddStuffForm());
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    print(user);

    //return either home or authenticate widget??
    if (user == null) {
      return Login();
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('UniStuff'),
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
                icon: Icon(Icons.favorite),
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
            onPressed: () => _addStuff(context),
            backgroundColor: Colors.white54,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      );
    }
  }
}
