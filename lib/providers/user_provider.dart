import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  void addUserData({
    required User currentUser,
    required String userName,
    required String userImage,
    required String userEmail,
    required String type,
    required String idToken,
  }) async {
    await FirebaseFirestore.instance
        .collection("usersData")
        .doc(currentUser.uid)
        .set({
      "id": currentUser.uid,
      "userName": userName,
      "userEmial": userEmail,
      "userImage": userImage,
      "userUid": currentUser.uid,
      "type": type,
      "idToken":idToken
    });
  }
}
