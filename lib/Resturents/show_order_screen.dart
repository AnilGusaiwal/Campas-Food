import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zometo/models/review_card_model.dart';
import 'package:http/http.dart' as http;

import 'drawer2/drawerRes.dart';

class ShowOrderScreen extends StatefulWidget {
  const ShowOrderScreen({Key? key}) : super(key: key);

  @override
  State<ShowOrderScreen> createState() => _ShowOrderScreen();
}

class _ShowOrderScreen extends State<ShowOrderScreen> {
  List<Widget>? screen;
  String? mtoken = " ";
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var select = 0;
  @override
  void initState() {
    screen = [home(), ongoing(), complete()];
    requestPermission();
    loadFCM();
    listenFCM();
    super.initState();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  AndroidNotificationChannel? channel;
  void loadFCM() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
      enableVibration: true,
    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(channel!.id);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel!.id,
              channel!.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              playSound: true,
              sound: RawResourceAndroidNotificationSound('notification'),
              priority: Priority.high,
              importance: Importance.high,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  // Widget item(String Address) {
  //   return Card(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
  //     child: Container(
  //       margin: EdgeInsets.symmetric(horizontal: 5),
  //       //height: 80,
  //       width: 330,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       child: Padding(
  //         padding:
  //             const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
  //         child: Row(children: [
  //           Expanded(
  //               child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               Container(
  //                 decoration: BoxDecoration(
  //                     color: Color.fromARGB(255, 139, 51, 144),
  //                     borderRadius: BorderRadius.circular(5)),
  //                 child: Text(
  //                   "$Address",
  //                   style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //             ],
  //           )),
  //           Container(
  //               child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.end,
  //                   children: [
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(20))),
  //                   child: const Text(
  //                     '  Accept  ',
  //                     style: TextStyle(fontSize: 13),
  //                   ),
  //                   onPressed: () {},
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(3.0),
  //                   child: ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(20))),
  //                     child: const Text(
  //                       'Reject',
  //                       style: TextStyle(fontSize: 13),
  //                     ),
  //                     onPressed: () {},
  //                   ),
  //                 ),
  //               ]))
  //         ]),
  //       ),
  //     ),
  //   );
  // }

  void sendPushMessage(String body, String title, String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              "key=AAAAn6QIGkU:APA91bEoglzwVsWOEb3AqBFjSWsmVvl_8irWrZBkioj66wwWDbvkV11I5ocsznhSCf0eX2VTgLyWJ7rLYm38HQJ0-YPPimWdgzAUWR3XRFfxK4_8GbfN8ro04dix6Ye9LouO9-BpBhJm"
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      print('done');
    } catch (e) {
      print("error push notification");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerRes(),
      backgroundColor: Color(0xfff6f1f1df),
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black87),
          title: Padding(
            padding: const EdgeInsets.only(top: 8, right: 2),
            child: const Text('🅲🅰🅼🅿🅰🆂 🅵🅾🅾🅳',
                style: TextStyle(color: Colors.black87)),
          ),
          backgroundColor: Color(0xffd6d738),
          actions: []),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xffd6d738),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  select = 0;
                });
              },
              icon: select == 0
                  ? const Icon(
                      Icons.home_filled,
                      color: Colors.black87,
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  select = 1;
                });
              },
              icon: select == 1
                  ? const Icon(
                      Icons.work_rounded,
                      color: Colors.black87,
                      size: 35,
                    )
                  : const Icon(
                      Icons.work_outline_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  select = 2;
                });
              },
              icon: select == 2
                  ? const Icon(
                      Icons.widgets_rounded,
                      color: Colors.black87,
                      size: 35,
                    )
                  : const Icon(
                      Icons.widgets_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
          ],
        ),
      ),
      body: screen![select],
    );
  }

  Widget home() {
    return Container(
      width: double.infinity,
      height: double.infinity,
     
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("Restaurants")
            .where("accepted", isEqualTo: false)
            .where("rejected", isEqualTo: false)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.amber,
                  strokeWidth: 1,
                ),
              );

              break;
            default:
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else {
                List<QueryDocumentSnapshot<Map<String, dynamic>>> roomlist =
                    snapshot.data!.docs;
                return ListView.builder(
                  itemCount: roomlist.length,
                  itemBuilder: (context, index) {
                    var data = roomlist[index].data();
                    Timestamp dateTime = data["dateTime"];
                    double amount = data['amount'];

                    return item4(data["room_ref"], roomlist[index].id, dateTime,
                        amount, data["reviewcard_id"]);
                  },
                );
              }
          }
        },
      ),
    );
  }

  Widget ongoing() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("Restaurants")
            .where("accepted", isEqualTo: true)
            .where("rejected", isEqualTo: false)
            .where("complete", isEqualTo: false)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.amber,
                  strokeWidth: 1,
                ),
              );

            default:
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                List<QueryDocumentSnapshot<Map<String, dynamic>>> roomlist =
                    snapshot.data!.docs;
                return ListView.builder(
                  itemCount: roomlist.length,
                  itemBuilder: (context, index) {
                    var data = roomlist[index].data();
                    Timestamp dateTime = data['dateTime'];
                    double amount = data["amount"];
                    return item5(data["room_ref"], roomlist[index].id, dateTime,
                        amount, data["reviewcard_id"]);
                  },
                );
              }
          }
        },
      ),
    );
  }

  Widget complete() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, image: AssetImage('assets/bgimage.png')),
      ),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("Restaurants")
            .where("accepted", isEqualTo: true)
            .where("rejected", isEqualTo: false)
            .where("complete", isEqualTo: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.amber,
                  strokeWidth: 1,
                ),
              );

              break;
            default:
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                List<QueryDocumentSnapshot<Map<String, dynamic>>> roomlist =
                    snapshot.data!.docs;
                return ListView.builder(
                  itemCount: roomlist.length,
                  itemBuilder: (context, index) {
                    var data = roomlist[index].data();
                    return item3(data["room_ref"], roomlist[index].id);
                  },
                );
              }
          }
        },
      ),
    );
  }

  Widget item1(String Address, String id, String rv) {
    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Restaurants")
              .where({"accepted": false})
              .where({"rejected": false})
              .orderBy("dateTime")
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.amber,
                      strokeWidth: 1,
                    ),
                  );

                default:
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> list =
                        snapshot.data!.docs;
                    List<Widget> d = [];
                    list.forEach((element) {
                      final Map<String, dynamic> doc = element.data();
                      ReviewCartModel data1 = ReviewCartModel.fromJson(doc);

                      d.add(
                          Text("${data1.cartName}    ${data1.cardQuantity}\n"));
                    });
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        //height: 80,
                        width: 330,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 5, bottom: 5),
                          child: Row(children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 139, 51, 144),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    "$Address",

                                    /// adress=Hall no. + room No.
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ExpansionTile(
                                  title: const Text(
                                    "Details",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  children: d.map((e) => e).toList(),
                                )
                              ],
                            )),
                            Container(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    child: const Text(
                                      '  Accept  ',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    onPressed: () async {
                                      Map<String, dynamic> data =
                                          new Map<String, dynamic>();
                                      data.addAll({"accepted": true});
                                      await FirebaseFirestore.instance
                                          .collection("Restaurants")
                                          .doc(id)
                                          .update(data)
                                          .then((value) {
                                        FirebaseFirestore.instance
                                            .collection("usersData")
                                            .doc(rv)
                                            .get()
                                            .then((value) {
                                          var dd = value.data();
                                          print(dd);
                                          sendPushMessage(
                                              "your request accepted",
                                              "Compas Food",
                                              dd!["device_token"]);
                                        });
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      child: const Text(
                                        'Reject',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      onPressed: () async {
                                        Map<String, dynamic> data =
                                            new Map<String, dynamic>();
                                        data.addAll({"rejected": true});
                                        await FirebaseFirestore.instance
                                            .collection("Restaurants")
                                            .doc(id)
                                            .update(data)
                                            .then((value) {
                                          FirebaseFirestore.instance
                                              .collection("usersData")
                                              .doc(rv)
                                              .get()
                                              .then((value) {
                                            var dd = value.data();
                                            print(dd);
                                            sendPushMessage(
                                                "this time your Order Items Not Availeble",
                                                "Compas Food",
                                                dd!["device_token"]);
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                ]))
                          ]),
                        ),
                      ),
                    );
                  }
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.amber,
                  strokeWidth: 1,
                ),
              );
            }
          }),
    );
  }

  Widget item2(String Address, String id, String rv) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        //height: 80,
        width: 330,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          child: Row(children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 139, 51, 144),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "$Address",

                    /// adress=Hall no. + room No.
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )),
            Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text(
                      '  Complete  ',
                      style: TextStyle(fontSize: 13),
                    ),
                    onPressed: () async {
                      Map<String, dynamic> data = new Map<String, dynamic>();
                      data.addAll({"complete": true});
                      await FirebaseFirestore.instance
                          .collection("Restaurants")
                          .doc(id)
                          .update(data)
                          .then((value) {
                        FirebaseFirestore.instance
                            .collection("usersData")
                            .doc(rv)
                            .get()
                            .then((value) {
                          var dd = value.data();
                          print(dd);
                          sendPushMessage(
                              "Your order has been completed. Arrived quickly at the canteen.",
                              "Compas Food",
                              dd!["device_token"]);
                        });
                      });
                      ;
                    },
                  ),
                ]))
          ]),
        ),
      ),
    );
  }

  Widget item3(String Address, String id) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        //height: 80,
        width: 330,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          child: Row(children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 139, 51, 144),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "$Address",

                    /// adress=Hall no. + room No.
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )),
            Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text(
                      '  Delete  ',
                      style: TextStyle(fontSize: 13),
                    ),
                    onPressed: () async {
                      Map<String, dynamic> data = new Map<String, dynamic>();
                      data.addAll({"accepted": true});
                      await FirebaseFirestore.instance
                          .collection("Restaurants")
                          .doc(id)
                          .delete();
                    },
                  ),
                ]))
          ]),
        ),
      ),
    );
  }

  Widget item4(
      String Address, String id, Timestamp dateTime, double amount, String rv) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Restaurantss")
            .doc(rv)
            .collection("data")
            .doc(id)
            .collection("OrderData")
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/favicon.png'),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      Address,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const Text(
                                      "IIT Kanpur,Kanpur",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color.fromARGB(
                                              255, 131, 116, 116)),
                                    ),
                                    Text(
                                      "${dateTime.toDate()}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color.fromARGB(
                                              255, 131, 116, 116)),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  " ₹ $amount",
                                  style: TextStyle(fontSize: 21),
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
                            child: ExpansionTile(
                          initiallyExpanded: true,
                          title: const Text(
                            "Details",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            String item = document["item"];

                            return Text(
                              item,
                              style: const TextStyle(fontSize: 16),
                            );
                          }).toList(),
                        )),
                      ),
                      Container(
                        height: 35,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0)),
                                  color: Colors.green,
                                ),
                                child: TextButton(
                                  child: Text("Accept",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  onPressed: () {
                                    Map<String, dynamic> data =
                                        new Map<String, dynamic>();
                                    data.addAll({"accepted": true});
                                    FirebaseFirestore.instance
                                        .collection("Restaurantss")
                                        .doc(rv)
                                        .collection("data")
                                        .doc(id)
                                        .update(data);

                                    FirebaseFirestore.instance
                                        .collection("Restaurants")
                                        .doc(id)
                                        .update(data)
                                        .then((value) {
                                      FirebaseFirestore.instance
                                          .collection("usersData")
                                          .doc(rv)
                                          .get()
                                          .then((value) {
                                        var dd = value.data();
                                        print(dd);
                                        sendPushMessage("your request accepted",
                                            "Compas Food", dd!["device_token"]);
                                      });
                                    });
                                  },
                                ),
                                height: 40,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0)),
                                  color: Colors.red,
                                ),
                                child: TextButton(
                                  child: Text("Reject",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  onPressed: () async {
                                    Map<String, dynamic> data =
                                        new Map<String, dynamic>();
                                    data.addAll({"rejected": true});
                                    await FirebaseFirestore.instance
                                        .collection("Restaurantss")
                                        .doc(rv)
                                        .collection("data")
                                        .doc(id)
                                        .update(data);
                                    await FirebaseFirestore.instance
                                        .collection("Restaurants")
                                        .doc(id)
                                        .update(data);
                                    await FirebaseFirestore.instance
                                        .collection("usersData")
                                        .doc(rv)
                                        .get()
                                        .then((value) {
                                      value.data()!["device_token"];

                                      sendPushMessage(
                                          "this time your Order Item is Not Availeble",
                                          "Compas Food",
                                          value.data()!["device_token"]);
                                    });
                                  },
                                ),
                                height: 40,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            );
          }
          return Container();
        });
  }

  Widget item5(
      String Address, String id, Timestamp dateTime, double amount, String rv) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Restaurantss")
            .doc(rv)
            .collection("data")
            .doc(id)
            .collection("OrderData")
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/favicon.png'),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      Address,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const Text(
                                      "IIT Kanpur,Kanpur",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color.fromARGB(
                                              255, 131, 116, 116)),
                                    ),
                                    Text(
                                      "${dateTime.toDate()}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color.fromARGB(
                                              255, 131, 116, 116)),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  " ₹ $amount",
                                  style: TextStyle(fontSize: 21),
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
                            child: ExpansionTile(
                          initiallyExpanded: false,
                          title: const Text(
                            "Details",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            String item = document["item"];

                            return Text(
                              item,
                              style: const TextStyle(fontSize: 16),
                            );
                          }).toList(),
                        )),
                      ),
                      Container(
                        height: 35,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.green,
                                ),
                                child: TextButton(
                                  child: Text("Complete",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  onPressed: () async {
                                    Map<String, dynamic> data =
                                        new Map<String, dynamic>();
                                    data.addAll({"complete": true});

                                    FirebaseFirestore.instance
                                        .collection("Restaurantss")
                                        .doc(rv)
                                        .collection("data")
                                        .doc(id)
                                        .update({"complete": true});

                                    await FirebaseFirestore.instance
                                        .collection("Restaurants")
                                        .doc(id)
                                        .update(data)
                                        .then((value) {
                                      FirebaseFirestore.instance
                                          .collection("usersData")
                                          .doc(rv)
                                          .get()
                                          .then((value) {
                                        var dd = value.data();
                                        print(dd);
                                        sendPushMessage(
                                            "Your order has been completed. Arrived quickly at the canteen.",
                                            "Compas Food",
                                            dd!["device_token"]);
                                      });
                                    });
                                    ;
                                  },
                                ),
                                height: 40,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            );
          }
          return Container();
        });
  }
}
