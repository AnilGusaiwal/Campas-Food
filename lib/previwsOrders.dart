import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zometo/config/colors.dart';

class MyOrders extends StatefulWidget {
  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [],
        title: Text(
          "MyOrders",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Restaurantss")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("data").orderBy("dateTime",descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Timestamp dateTime = document["dateTime"];
                    print(dateTime.toDate());
                    bool rejected = document['rejected'] as bool;
                     bool accepted = document['accepted'] as bool;
                      bool complete = document['complete'] as bool;
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Restaurantss")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("data")
                            .doc(document.id)
                            .collection("OrderData")
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot2) {
                          if (snapshot2.hasData) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      width: 1,
                                      color: Color.fromARGB(255, 153, 151, 151),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 90,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Image.asset('assets/favicon.png'),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "Hall-5 Cantten",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                   const Text(
                                                      "IIT Kanpur,Kanpur",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Color.fromARGB(
                                                              255,
                                                              131,
                                                              116,
                                                              116)),
                                                    ),
                                                    Text(
                                                      "${dateTime.toDate()}",
                                                      style:  const TextStyle(
                                                          fontSize: 12,
                                                          color: Color.fromARGB(
                                                              255,
                                                              131,
                                                              116,
                                                              116)),
                                                    ),
                                                    Tpye(accepted, rejected,
                                                        complete)
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 60,
                                                child: Text(
                                                  " ₹ ${document["amount"]}",
                                                  style:
                                                      TextStyle(fontSize: 21),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          height: 130,
                                          child: ListView(
                                            children: snapshot2.data!.docs.map(
                                                (DocumentSnapshot document) {
                                              String item = document["item"];

                                              return Text(
                                                item,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            );
                          }

                          return Container();
                        });
                  }).toList(),
                ),
              );
            }
            return Container();
          }),
    );
  }

  Widget Tpye(bool Accepted, bool Rejected, bool Complete) {
    if (Accepted == false && Rejected == false) {
      return Text(
        "Waiting",
        style: TextStyle(fontSize: 17, color: Color.fromARGB(255, 54, 19, 135)),
      );
    }
    if (Rejected == true) {
      return Text(
        "Rejected",
        style: TextStyle(fontSize: 17, color: Colors.red),
      );
    }
    if (Accepted == true && Complete == false) {
      return Text(
        "Started",
        style: TextStyle(fontSize: 17, color: Color.fromARGB(255, 19, 135, 27)),
      );
    }
    if (Complete == true) {
      return Text(
        "Complete",
        style: TextStyle(fontSize: 17, color: Color.fromARGB(255, 19, 135, 27)),
      );
    }
    return Text("");
  }
}
