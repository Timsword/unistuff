import 'package:firebase_auth/firebase_auth.dart';
import 'package:unistuff_main/models/MyUser.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; //private data member

  //create MyUser object based on FirebaseUser
  MyUser? _userfromFirebase(User user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<MyUser?>? get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userfromFirebase(user!));
  }

  //sign in with email & password
  Future signInWithMail() async {
    try {} catch (e) {}
  }

  //register with email & password

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
