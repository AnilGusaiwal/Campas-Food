import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zometo/homeStream.dart';
import 'package:zometo/Resturents/show_order_screen.dart';

import 'auth/sign_in.dart';
import 'models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SpplashScreenState();
}

class _SpplashScreenState extends State<SplashScreen> {
  UserModel? userModel;
  late Timer _timer;
  String? usertype;

  @override
  void initState() {
    _timer = Timer(Duration(milliseconds: 2000), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      FirebaseFirestore.instance
                          .collection("usersData")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get()
                          .then((value) {
                        if (value.data()!.containsKey("type")) {
                          UserModel usermodel =
                              UserModel.fromJson(value.data()!);
                          if (usermodel.type == "Restaurant") {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return ShowOrderScreen();
                            }));
                          } else {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return Home_Screen3();
                            }));
                          }
                        } 
                        
                      }
                              //)
                              );
                    } else {
                      return SignIn();
                    }
                    return  SplashScreen();
                  })));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 1,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/icon.png')),
            ],
          ),
        ),
      ),
    ));
  }
}
