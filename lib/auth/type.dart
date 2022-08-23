import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zometo/homeStream.dart';
import 'package:zometo/models/user_model.dart';
import 'package:zometo/providers/user_provider.dart';
import 'package:zometo/Resturents/show_order_screen.dart';

class Type_userapp extends StatefulWidget {
  User user;
  Type_userapp({required this.user});

  @override
  State<Type_userapp> createState() => _Type_userappState();
}

class _Type_userappState extends State<Type_userapp> {
  late UserProvider userProvider;
  late Timer _timer;
  @override
  void initState() {
    // _timer = Timer(
    //     const Duration(milliseconds: 1),
    //     () => 
        FirebaseFirestore.instance
                .collection("usersData")
                .doc(widget.user.uid)
                .get()
                .then((value) {
              if (value.data()!.containsKey("type")) {
                UserModel usermodel = UserModel.fromJson(value.data()!);
                if (usermodel.type == "Restaurant") {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return ShowOrderScreen();
                  }));
                } else {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return Home_Screen3();
                  }));
                }
              } else {
                super.initState();
              }
            }
            //)
            );
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Container(
        color: Colors.white,
          width: MediaQuery.of(context).size.width*1,
          height: MediaQuery.of(context).size.height*1,
           
                child: ListView(
                  shrinkWrap: true,

            
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 70,),
                 Row(children: const [
                   
                     Text("     Good  ",style: TextStyle(fontSize: 45,fontWeight: FontWeight.bold),),
                       Text("Food",style: TextStyle(fontSize: 45,fontWeight: FontWeight.bold),),

                  ],
                ),
                 Row(children: const [
                   
                    Text("     Great ",style: TextStyle(fontSize: 45,fontWeight: FontWeight.bold),),
                     Text("Life !",style: TextStyle(fontSize: 45,fontWeight: FontWeight.bold),),

                  ],
                 ),
                 SizedBox(height: 40,),
             
                const Image(image: AssetImage('assets/chef.png')),
                    const SizedBox(height: 40,),
                
                Center(
                      child: Container(
                        width: 200,
                        height: 40,
                        child: OutlinedButton(
                            onPressed: ()  {
                              
                      userProvider.addUserData(
                          currentUser: widget.user,
                          userName: widget.user.displayName!,
                          userEmail: widget.user.email!,
                          userImage: widget.user.photoURL!,
                          type: "Customer");
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (context) {
                        return Home_Screen3();
                      }));
                            },
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              backgroundColor: Colors.black87,
                            )),
                      ),
                    ),

            ],
          
              )),
    );
  }
}
