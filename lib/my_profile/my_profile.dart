import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zometo/DrawerPages/drawer_page.dart';
import 'package:zometo/auth/sign_in.dart';
import 'package:zometo/config/colors.dart';
import 'package:zometo/models/user_model.dart';
import 'package:zometo/my_profile/about.dart';

class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  UserModel? userModel;
  final Uri urlTC = Uri(
      scheme: 'https',
      host: 'pages.flycricket.io',
      path: 'neatroot/terms.html');
  final Uri urlPP = Uri(
      scheme: 'https',
      host: 'pages.flycricket.io',
      path: 'neatroot/terms.html');

  Widget listTile({required IconData icon, required String title}) {
    return Column(
      children: [
        Divider(
          height: 1,
        ),
        ListTile(
            leading: Icon(icon),
            title: Text(title),
            trailing: Icon(Icons.arrow_forward_ios))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "My Profile",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Drawer_page(),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("usersData")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>?> snapshot) {
            if (snapshot.hasData) {
              userModel = UserModel.fromJson(snapshot.data!.data()!);
              return Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 100,
                        color: primaryColor,
                        margin: EdgeInsets.only(left: 150),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userModel!.UserName,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: textColor),
                                ),
                                Flexible(
                                    child: Text(
                                  userModel!.Email,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                Text('Id = I-304 Hall-5'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 503,
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: ListView(
                          children: [
                            listTile(
                                icon: Icons.shop_outlined, title: "My Orders"),
                            listTile(
                                icon: Icons.person_outlined,
                                title: "Refer A Friends"),
                            InkWell(
                              child: listTile(
                                  icon: Icons.file_copy_outlined,
                                  title: "Terms & Conditions"),
                              onTap: () {
                                _launchInBrowser(urlTC);
                              },
                            ),
                            InkWell(
                              child: listTile(
                                  icon: Icons.policy_outlined,
                                  title: "Privacy Policy"),
                              onTap: () {
                                _launchInBrowser(urlPP);
                              },
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => About()));
                              },
                              child: listTile(
                                  icon: Icons.add_card_outlined,
                                  title: "About"),
                            ),
                            InkWell(
                              onTap: () async {
                                await FirebaseAuth.instance.signOut().then(
                                    (value) => Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                                builder: (context) {
                                          return SignIn();
                                        })));
                              },
                              child: listTile(
                                  icon: Icons.exit_to_app_outlined,
                                  title: "Log Out"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 30),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 43,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(userModel!.UserImage),
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          right: -3,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: primaryColor,
                            child: CircleAvatar(
                              radius: 15,
                              child: Icon(
                                Icons.edit,
                                color: primaryColor,
                              ),
                              backgroundColor: scaffoldBackgroundColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Expanded(child: Container(color: Colors.white,))
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}
