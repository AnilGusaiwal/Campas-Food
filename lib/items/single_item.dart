import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zometo/config/colors.dart';
import 'package:zometo/models/review_card_model.dart';

import '../providers/review_card_provider.dart';

class SingleItems extends StatefulWidget {
  ReviewCartModel reviewCartModel;
  bool isBool = false;

  SingleItems({required this.isBool, required this.reviewCartModel});

  @override
  State<SingleItems> createState() => _SingleItems2State();
}

class _SingleItems2State extends State<SingleItems> {
  int totalItems = 1;
  Widget build(BuildContext context) {
    int homeQuantity = 0;
    ReviewCardProvider reviewCardProvider = Provider.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 100,
              child: Center(
                child: Image.network(widget.reviewCartModel.cartImage),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        widget.reviewCartModel.cartName,
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      // Text(
                      //   " ₹ ${widget.reviewCartModel.cartPrice}",
                      //   style: TextStyle(color: Colors.grey, fontSize: 15),
                      // ),
                    ],
                  ),
                  Text(
                      " ₹ ${widget.reviewCartModel.cartPrice.toDouble().toStringAsFixed(2)}"),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 100,
              child: Container(
                height: 100,
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Delete Item"),
                                content: Text("Are you sure?"),
                                actions: [
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection("ReviewCart")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection("YourReviewCart")
                                          .doc(widget.reviewCartModel.cartId)
                                          .delete();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: Text("cancel"),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                              ;
                            },
                          );
                        },
                        child: Container(
                          height: 25,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child:
                                Icon(Icons.delete, size: 25, color: Colors.red),
                          ),
                        )),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                reviewCardProvider.addReviewCartrData(
                                  cartId: widget.reviewCartModel.cartId,
                                  cartImage: widget.reviewCartModel.cartImage,
                                  cartName: widget.reviewCartModel.cartName,
                                  cartPrice: widget.reviewCartModel.cartPrice,
                                  cardQuantity:
                                      widget.reviewCartModel.cardQuantity + 1,
                                  isAdd: true,
                                );
                              });
                            },
                            child: Icon(
                              Icons.add,
                              color: primaryColor,
                              size: 20,
                            ),
                          ),
                          Text(
                            "${widget.reviewCartModel.cardQuantity}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          InkWell(
                            onTap: (() {
                              setState(() {
                                if (widget.reviewCartModel.cardQuantity == 1) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Delete Item"),
                                        content: Text("Are you sure?"),
                                        actions: [
                                          TextButton(
                                            child: Text("OK"),
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection("ReviewCart")
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .collection("YourReviewCart")
                                                  .doc(widget
                                                      .reviewCartModel.cartId)
                                                  .delete();
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text("cancel"),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                      ;
                                    },
                                  );
                                } else
                                  reviewCardProvider.addReviewCartrData(
                                    cartId: widget.reviewCartModel.cartId,
                                    cartImage: widget.reviewCartModel.cartImage,
                                    cartName: widget.reviewCartModel.cartName,
                                    cartPrice: widget.reviewCartModel.cartPrice,
                                    cardQuantity:
                                        widget.reviewCartModel.cardQuantity - 1,
                                    isAdd: true,
                                  );
                              });
                            }),
                            child: Icon(
                              Icons.remove,
                              color: primaryColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
          )
        ],
      ),
    );
  }
}
