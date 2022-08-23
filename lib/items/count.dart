import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zometo/providers/review_card_provider.dart';

class Count extends StatefulWidget {
  @override
  String productName;
  String productImage;
  String productId;
  int productQuantity;
  int productPrice;

  Count(
      {required this.productName,
      required this.productPrice,
      required this.productImage,
      required this.productId,
      required this.productQuantity});

  State<Count> createState() => _CountState();
}

class _CountState extends State<Count> {
  int count = 0;
  bool isTrue = false;
  // getAddAndQuantity() {
  //   FirebaseFirestore.instance
  //       .collection("ReviewCard")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection("YourReviewCard")
  //       .get()
  //       .then((value) => {
  //             value.docs.forEach((element) {
  //               print(element.data());
  //               setState(() {
  //                 isTrue = element.get("isAdd");
  //               });
  //             })
  //           });
  // }

  @override
  Widget build(BuildContext context) {
    ReviewCardProvider reviewCardProvider = Provider.of(context);
    return Container(
      height: 30,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.yellow,
        border: Border.all(color: Colors.black.withOpacity(0.7)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: isTrue == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (count == 1) {
                          setState(() {
                            isTrue = false;
                            count--;
                          });

                          await FirebaseFirestore.instance
                              .collection("ReviewCart")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("YourReviewCart")
                              .doc(widget.productId)
                              .delete();
                        } else {
                          setState(() {
                            count--;
                          });
                          reviewCardProvider.addReviewCartrData(
                            cartId: widget.productId,
                            cartImage: widget.productImage,
                            cartName: widget.productName,
                            cartPrice: widget.productPrice,
                            cardQuantity: count,
                            isAdd: true,
                          );
                        }
                      },
                      child: Icon(
                        Icons.remove,
                        size: 17,
                      ),
                    ),
                    Text(
                      "${count}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 17),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          count++;
                        });
                        reviewCardProvider.addReviewCartrData(
                          cartId: widget.productId,
                          cartImage: widget.productImage,
                          cartName: widget.productName,
                          cartPrice: widget.productPrice,
                          cardQuantity: count,
                          isAdd: true,
                        );
                      },
                      child: Icon(
                        Icons.add,
                        size: 17,
                      ),
                    )
                  ],
                )
              : Center(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isTrue = true;
                        count = 1;
                      });
                      reviewCardProvider.addReviewCartrData(
                        cartId: widget.productId,
                        cartImage: widget.productImage,
                        cartName: widget.productName,
                        cartPrice: widget.productPrice,
                        cardQuantity: count,
                        isAdd: true,
                      );
                    },
                    child: Text("ADD",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 17)),
                  ),
                )),
    );
  }
}
