import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upi_pay/upi_pay.dart';
import 'package:http/http.dart' as http;
import 'package:zometo/config/colors.dart';
import 'package:zometo/models/review_card_model.dart';
import 'package:zometo/previwsOrders.dart';

import '../providers/review_card_provider.dart';

class UpiPayment extends StatefulWidget {
  var amount;
  var reviewcard_id;
  final String upiId;
  var order;
  String? PaymentStutas;
  final Map<String, String> cardMap;
  UpiPayment({
    required this.amount,
    this.order,
    this.reviewcard_id,
    required this.cardMap,
    required this.upiId,
  });
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<UpiPayment> {
  String? _upiAddrError;
  DateTime dateTime = DateTime.now();

  final _upiAddressController = TextEditingController();
  final _amountController = TextEditingController();
  late ReviewCardProvider reviewCardProvider;
  late Timer _timer;

  bool _isUpiEditable = false;
  List<ApplicationMeta>? _apps;

  @override
  void initState() {
    super.initState();
    reviewCardProvider = Provider.of(context, listen: false);
    reviewCardProvider.getReviewCartData();

    _amountController.text = " ₹ ${widget.amount}";

    Future.delayed(Duration(milliseconds: 0), () async {
      _apps = await UpiPay.getInstalledUpiApplications(
          statusType: UpiApplicationDiscoveryAppStatusType.all);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _upiAddressController.dispose();
    super.dispose();
  }

  Future<void> _onTap(ApplicationMeta app) async {
    final err = RoomAddress(_upiAddressController.text);
    print(widget.order);
    if (err != null) {
      setState(() {
        _upiAddrError = err;
      });
      return;
    }
    setState(() {
      _upiAddrError = null;
    });

    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    print("Starting transaction with id $transactionRef");

    final a = await UpiPay.initiateTransaction(
      amount: "1",
      // amount: "${widget.amount}",
      app: app.upiApplication,
      receiverName: 'Campus Food',
      receiverUpiAddress: widget.upiId,
      transactionRef: transactionRef,
      transactionNote: 'UPI Payment',
      // merchantCode: '7372',
    ).then((UpiTransactionResponse value) {
      print(value.status);
      _checkTxnStatus(value.status!);
    });
  }

  final snackbar = SnackBar(
    content: Text("the order empty"),
    backgroundColor: Colors.red,
  );
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

  // void sendMessage(context) {
  //   var txt = widget.order;
  //   print(txt);
  //   if (txt.length < 10) {
  //     ScaffoldMessenger.of(context).showSnackBar(snackbar);
  //   } else {
  //     _launchURL(txt);
  //   }
  // }

  // var _url = "https://api.whatsapp.com/send?phone=919587691547";
  // void _launchURL(txt) async => await canLaunch(_url + "tx")
  //     ? await launch(_url + txt).then((value) {
  //         if (value)
  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             content: Text("order sended"),
  //             backgroundColor: Colors.red,
  //           ));
  //         else
  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             content: Text("order failed "),
  //             backgroundColor: Colors.red,
  //           ));
  //         return;
  //       })
  //     : throw 'Could not launch $_url';

  void _checkTxnStatus(UpiTransactionStatus status) {
    switch (status) {
      case UpiTransactionStatus.success:
        {
          String id =
              FirebaseFirestore.instance.collection("Restaurants").doc().id;

          widget.cardMap.forEach((key, value) {
            FirebaseFirestore.instance
                .collection("Restaurantss")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("data")
                .doc(id)
                .collection("OrderData")
                .add({
              "item": value,
            });
          });

          FirebaseFirestore.instance
              .collection("Restaurantss")
              .doc(widget.reviewcard_id)
              .collection("data")
              .doc(id)
              .set({
            "room_ref": _upiAddressController.text,
            "amount": widget.amount,
            "accepted": false,
            "rejected": false,
            "complete": false,
            "reviewcard_id": widget.reviewcard_id,
            "dateTime": dateTime,
          });

          FirebaseFirestore.instance.collection("Restaurants").doc(id).set({
            "room_ref": _upiAddressController.text,
            "amount": widget.amount,
            "accepted": false,
            "rejected": false,
            "complete": false,
            "reviewcard_id": widget.reviewcard_id,
            "dateTime": dateTime
          }).then((value) async {
            await FirebaseFirestore.instance
                .collection("usersData")
                .where("type", isEqualTo: "Restaurant")
                .get()
                .then((value) {
              var ddd = value.docs;
              ddd.forEach((element) {
                var dd = element.data();
                sendPushMessage("new order From ${_upiAddressController.text}",
                    "Compass Order", dd["device_token"]);
              });
            });

            print('Transaction Successful');
          });
          setState(() {
            widget.PaymentStutas = "Order Successfully Placed";
          });
          _timer = Timer(Duration(milliseconds: 1000), () {
            Navigator.of(context).popAndPushNamed("/MyOrders");
          });
        }
        break;
      case UpiTransactionStatus.submitted:
        print('Transaction Submitted');
        break;
      case UpiTransactionStatus.failure:
        print('Transaction Failed');

        setState(() {
          widget.PaymentStutas = " Failed";
        });
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  @override
  Widget build(BuildContext context) {
    reviewCardProvider = Provider.of(context);
    print(widget.upiId);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Pay Now",
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.yellow,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: <Widget>[
              Center(
                child: TextButton(
                    onPressed: ()  {
                       FirebaseFirestore.instance
                          .collection("usersData")
                          .where("type", isEqualTo: "Restaurant")
                          .get()
                          .then((value) {
                        var ddd = value.docs;
                        ddd.forEach((element) {
                          var dd = element.data();
                          print(dd["device_token"]);
                          sendPushMessage(
                              "new order From ${_upiAddressController.text}",
                              "Compass Order",
                              dd["device_token"]);
                        });
                      });

                      print('Transaction Successful');
                    },
                    child: Text("gfghfghf")),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Enter Your Room No.",
                style: TextStyle(color: Colors.black87, fontSize: 20),
              ),
              _vpa(),
              if (_upiAddrError != null) _vpaError(),
              _amount(),
              if (Platform.isIOS) _submitButton(),
              Platform.isAndroid ? _androidApps() : _iosApps(),
              SizedBox(height: 20),
              widget.PaymentStutas != null
                  ? Container(
                      child: Center(
                        child: Text(
                          "Payment ${widget.PaymentStutas}",
                          style: TextStyle(color: Colors.black87, fontSize: 20),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vpa() {
    return Container(
      margin: EdgeInsets.only(top: 32),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: _upiAddressController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'I-304',
                labelText: 'Hall 5 Room No.',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vpaError() {
    return Container(
      margin: EdgeInsets.only(top: 4, left: 12),
      child: Text(
        _upiAddrError!,
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _amount() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _amountController,
              readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      margin: EdgeInsets.only(top: 32),
      child: Row(
        children: <Widget>[
          Expanded(
            child: MaterialButton(
              onPressed: () async => await _onTap(_apps![0]),
              child: Text('Initiate Transaction',
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(color: Colors.white)),
              color: Theme.of(context).accentColor,
              height: 48,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _androidApps() {
    return Container(
      margin: EdgeInsets.only(top: 32, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Text(
              'Pay Using',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          if (_apps != null) _appsGrid(_apps!.map((e) => e).toList()),
        ],
      ),
    );
  }

  Widget _iosApps() {
    return Container(
      margin: EdgeInsets.only(top: 32, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 24),
            child: Text(
              'One of these will be invoked automatically by your phone to '
              'make a payment',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Text(
              'Detected Installed Apps',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          if (_apps != null) _discoverableAppsGrid(),
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            child: Text(
              'Other Supported Apps (Cannot detect)',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          if (_apps != null) _nonDiscoverableAppsGrid(),
        ],
      ),
    );
  }

  GridView _discoverableAppsGrid() {
    List<ApplicationMeta> metaList = [];
    _apps!.forEach((e) {
      if (e.upiApplication.discoveryCustomScheme != null) {
        metaList.add(e);
      }
    });
    return _appsGrid(metaList);
  }

  GridView _nonDiscoverableAppsGrid() {
    List<ApplicationMeta> metaList = [];
    _apps!.forEach((e) {
      if (e.upiApplication.discoveryCustomScheme == null) {
        metaList.add(e);
      }
    });
    return _appsGrid(metaList);
  }

  GridView _appsGrid(List<ApplicationMeta> apps) {
    apps.sort((a, b) => a.upiApplication
        .getAppName()
        .toLowerCase()
        .compareTo(b.upiApplication.getAppName().toLowerCase()));
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      // childAspectRatio: 1.6,
      physics: NeverScrollableScrollPhysics(),
      children: apps
          .map(
            (it) => Material(
              key: ObjectKey(it.upiApplication),
              // color: Colors.grey[200],
              child: InkWell(
                onTap: Platform.isAndroid ? () async => await _onTap(it) : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    it.iconImage(48),
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      alignment: Alignment.center,
                      child: Text(
                        it.upiApplication.getAppName(),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

String? RoomAddress(String value) {
  if (value.isEmpty) {
    return 'Enter Room No.';
  }

  return null;
}
