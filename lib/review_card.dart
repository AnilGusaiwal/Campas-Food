import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zometo/models/review_card_model.dart';
import 'package:zometo/payment/upisecond.dart';
import 'package:zometo/providers/review_card_provider.dart';
import 'package:zometo/items/single_item.dart';

class Review_Card extends StatefulWidget {
  @override
  State<Review_Card> createState() => _Review_CardState();
}

class _Review_CardState extends State<Review_Card> {
  late ReviewCardProvider reviewCardProvider;
  double amount = 0.0;
  String order = "order \n";
  String? reviewid;

  Map<String, String> cardMap = HashMap();
  @override
  void initState() {
    reviewCardProvider = Provider.of(context, listen: false);
    reviewCardProvider.getReviewCartData();
    reviewCardProvider.upiIdFirebase();

    setState(() {
      reviewid = FirebaseAuth.instance.currentUser!.uid;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    reviewCardProvider = Provider.of(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black87),
          backgroundColor: const Color(0xffd6d738),
          actions: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("ReviewCart")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("YourReviewCart")
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData) {
                    return Stack(children: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Review_Card()));
                        },
                      ),
                      snapshot.data!.docs.isEmpty
                          ? Container()
                          : Positioned(
                              child: Stack(
                              children: <Widget>[
                                const Icon(Icons.brightness_1,
                                    size: 22.0,
                                    color: Color.fromARGB(255, 208, 5, 73)),
                                Positioned(
                                    top: 3.0,
                                    right: 4.0,
                                    child: Text(
                                      snapshot.data!.docs.isEmpty
                                          ? "0"
                                          : snapshot.data!.docs.length
                                              .toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ))
                    ]);
                  } else {
                    return const CircularProgressIndicator(
                      strokeWidth: 15.0,
                    );
                  }
                }),
          ],
          title: const Text(
            "Review Card",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
            ),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("ReviewCart")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("YourReviewCart")
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> list =
                  snapshot.data!.docs;
              cardMap.clear();

              Future.delayed(const Duration(milliseconds: 1), () {
                // deleayed code here
                setState(() {
                  amount = 0.0;
                  order = "order&";
                });
              });
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView(
                        children: snapshot.data!.docs.map(
                      (DocumentSnapshot document) {
                        ReviewCartModel data = model(document);

                        cardMap[data.cartName] = "${data.cardQuantity}" +
                            " × " +
                            data.cartName +
                            " / ₹ " +
                            ("${data.cartPrice}");

                        Future.delayed(const Duration(milliseconds: 1), () {
                          // deleayed code here
                          setState(() {
                            order = order + "${data.cartName}&";
                            amount =
                                amount + data.cartPrice * data.cardQuantity;
                          });
                        });

                        return Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            SingleItems(
                              isBool: true,
                              reviewCartModel: data,
                            ),
                            Divider(
                              height: 5,
                              color: Colors.green.withOpacity(0.5),
                            ),
                          ],
                        );
                      },
                    ).toList()),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ListTile(
                      title: const Text(
                        "total Amount",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                        "\₹ ${amount}",
                        style: TextStyle(
                            color: Colors.green[900],
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: Container(
                        width: 160,
                        child: MaterialButton(
                          child: const Text(
                            "Pay",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          color: Color(0xffd6d738),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UpiPayment(
                                      amount: amount,
                                      order: order,
                                      reviewcard_id: reviewid,
                                      cardMap: cardMap,
                                      upiId: reviewCardProvider.getUpiId,
                                    )));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return const Center(
              child: Text("NO DATA"),
            );
          },
        ));
  }
}

ReviewCartModel model(DocumentSnapshot documentSnapshot) {
  return ReviewCartModel(
    cartId: documentSnapshot['cardId'],
    cartImage: documentSnapshot['cardImage'],
    cartName: documentSnapshot['cardName'],
    cartPrice: documentSnapshot['cartPrice'],
    cardQuantity: documentSnapshot['cardQuantity'],
  );
}
