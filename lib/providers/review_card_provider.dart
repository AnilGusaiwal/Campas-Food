import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/review_card_model.dart';

class ReviewCardProvider with ChangeNotifier {
  void addReviewCartrData(
      {required String cartId,
      required String cartImage,
      required String cartName,
      required int cartPrice,
      var cardQuantity,
      bool? isAdd}) async {
    await FirebaseFirestore.instance
        .collection("ReviewCart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("YourReviewCart")
        .doc(cartId)
        .set({
      "cardId": cartId,
      "cardName": cartName,
      "cardImage": cartImage,
      "cartPrice": cartPrice,
      "cardQuantity": cardQuantity,
      "isAdd": true
    });
  }

  List<ReviewCartModel> reviewCartDataList = [];

  getReviewCartData() {
    return FirebaseFirestore.instance
        .collection("ReviewCart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("YourReviewCart")
        .get()
        .then((value) {
      for (var element in value.docs) {
        ReviewCartModel reviewCartModel = ReviewCartModel(
          cartId: element.data()["cardId"],
          cartImage: element.data()["cardImage"],
          cartName: element.data()["cardName"],
          cartPrice: element.data()["cartPrice"],
          cardQuantity: element.data()["cardQuantity"],
        );

        reviewCartDataList.add(reviewCartModel);
      }

      return reviewCartDataList;
    });
    notifyListeners();
  }

  List<ReviewCartModel> get getReviewCartDataList {
    return reviewCartDataList;
  }

  String upiId = "";

  upiIdFirebase() {
    FirebaseFirestore.instance
        .collection("Res Product")
        .doc("Hall-5")
        .get()
        .then((value) => upiId = value["upiId"]);
  }

  String get getUpiId {
    return upiId;
  }
}
