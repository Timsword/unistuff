import 'package:firebase_auth/firebase_auth.dart';
import 'package:unistuff_main/models/MyUser.dart';
import 'package:unistuff_main/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; //private data member

  //create MyUser object based on FirebaseUser
  MyUser? _userfromFirebase(User user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<MyUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userfromFirebase(user!));
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return _userfromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future regiterWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;

      //create new doc for the user with the uid
      ////başlangıç değeri atamaları
      await DatabaseService(uid: user.uid)
          .updateUserStuff('a new stuff', 'about my stuff', 100);

      return _userfromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
