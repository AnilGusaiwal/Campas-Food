import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:zometo/product_overview.dart';
import 'package:zometo/providers/product_provider.dart';
import 'package:zometo/review_card.dart';
import 'package:zometo/items/singal_product.dart';
import 'DrawerPages/drawer_page.dart';
import 'models/product_model.dart';
import 'search/search2.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Home_Screen3 extends StatefulWidget {
  @override
  State<Home_Screen3> createState() => _Home_Screen3State();
}

class _Home_Screen3State extends State<Home_Screen3> {
  late ProductProvider productProvider;

  String? mtoken = " ";
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection("Res Product")
      .doc("Hall-5")
      .collection("TypeList")
      .orderBy('num')
      .snapshots();

  @override
  void initState() {
    ProductProvider productProvider = Provider.of(context, listen: false);
    productProvider.getSameAllProduct();
    requestPermission();
    loadFCM();
    listenFCM();
  }

  getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      print(token);

      setState(() {
        mtoken = token;
      });
    }).then((value) async {
      Map<String, dynamic> data = new Map<String, dynamic>();
      data.addAll({"device_token": mtoken});
      await FirebaseFirestore.instance
          .collection("usersData")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);
    });
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
              playSound: true,
              sound: RawResourceAndroidNotificationSound('notification'),
              icon: 'launch_background',
              priority: Priority.high,
              importance: Importance.high,
            ),
          ),
        );
      }
    });
  }

  List<ProductModel>? getList(String id) {
    return productProvider.competeListMap[id];
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of(context);

    return Scaffold(
      backgroundColor: Color(0xfff6f1f1df),
      drawer: Drawer_page(),
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black87),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('DineEasy', style: TextStyle(color: Color.fromARGB(221, 47, 13, 13),fontSize:24 )),
            Text('Order Now', style: TextStyle(color: Colors.black87,fontSize:12 )),
          ],
        ),
        backgroundColor: Color(0xffd6d738),
        actions: [
         
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("ReviewCart")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("YourReviewCart")
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
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
                        return const CircularProgressIndicator();
                      } else {
                        return Stack(children: <Widget>[
                          IconButton(
                            icon: Icon(
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
                      }
                  }
                } else {
                  return IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Review_Card()));
                    },
                  );
                }
              }),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Color(0xffd6d738),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black87,
                ),
                onPressed: ()
                 {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Search2(
                          search: productProvider.getAllProductDataList)));
                },
                color: Colors.black,
              ),
              radius: 15,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return  Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.amber,
                      strokeWidth: 1,
                    ),
                  );

                default:
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          SizedBox(
                            height: 20,
                          );
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      document.id,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => Search2(
                                                      search:
                                                          getList(document.id),
                                                    )));
                                      },
                                      child: Row(
                                        children: const [
                                          Text(
                                            'View all',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.grid_on_sharp,
                                            size: 18,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("Res Product")
                                    .doc("Hall-5")
                                    .collection("AllData")
                                    .doc("CollectionList")
                                    .collection(document.id)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot2) {
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
                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: snapshot2.data!.docs
                                                  .map((DocumentSnapshot
                                                      document2) {
                                                Map<String, dynamic> data =
                                                    document2.data()!
                                                        as Map<String, dynamic>;

                                                const SizedBox(
                                                  width: 50,
                                                );
                                                return singalProduct(
                                                  productImage:
                                                      data['productImage'],
                                                  productName:
                                                      data["productName"],
                                                  productPrice:
                                                      data["productPrice"]
                                                          as int,
                                                  onTap: () {
                                                    // Navigator.of(context).push(
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                                // Product_Overview(
                                                                //   productImage:
                                                                //       data[
                                                                //           'productImage'],
                                                                //   productName: data[
                                                                //       "productName"],
                                                                //   productPrice:
                                                                //       data["productPrice"]
                                                                //           as int,
                                                                // )));
                                                  },
                                                  productid: data['productId'],
                                                );
                                              }).toList(),
                                            ),
                                          );
                                        }
                                    }
                                  
                                  } else {
                                    return const CircularProgressIndicator(
                                      strokeWidth: 15.0,
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  }
              }
            } else {
              return const CircularProgressIndicator(
                strokeWidth: 15.0,
              );
            }
          },
        ),
      ),
    );
  }
}
