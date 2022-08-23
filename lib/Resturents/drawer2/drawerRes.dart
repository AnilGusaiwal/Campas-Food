import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zometo/Resturents/drawer2/addItems.dart';
import 'package:zometo/Resturents/drawer2/addList.dart';
import 'package:zometo/Resturents/show_order_screen.dart';
import 'package:zometo/auth/sign_in.dart';
import 'package:zometo/homeStream.dart';
import 'package:zometo/my_profile/my_profile.dart';
import 'package:zometo/previwsOrders.dart';
import '../../models/user_model.dart';
import '../../review_card.dart';

class DrawerRes extends StatefulWidget {
  @override
  State<DrawerRes> createState() => _DrawerResState();
}

class _DrawerResState extends State<DrawerRes> {
  final Uri toLaunch =Uri(scheme: 'https', host: 'www.youtube.com');
  UserModel? userModel;
  Widget listTile(IconData icon, String title, void Function()? onTap) {
    return ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          size: 32,
          color: Colors.black87,
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.black87),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.yellow,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.yellow),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 40,
                  child: Text(
                    "Vegi",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.green,
                            offset: Offset(5, 5),
                          ),
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 20,
                  width: 20,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text('Welcome Guest'),
                    SizedBox(
                      height: 7,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("usersData")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>?>
                                snapshot) {
                          if (snapshot.hasData) {
                            userModel =
                                UserModel.fromJson(snapshot.data!.data()!);
                            return Text(userModel!.UserName);
                          }
                          return Container();
                        }),
                  ],
                ),
              ],
            ),
          ),
          listTile(
            Icons.home_outlined,
            'Home',
            () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ShowOrderScreen()));
            },
          ),
          
          listTile(
            Icons.add_card_outlined,
            'Add Items in List',
            () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) =>AddItemsInList() ));
            },
          ),
          listTile(
            Icons.list,
            'Add New List',
            () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddNewList()));
            },
          ),
          listTile(
            Icons.share,
            'Share with Friends',
            () {
              share();
            },
          ),
          listTile(
            Icons.rate_review_outlined,
            'Suggestion',
            () {
               _launchInBrowser(toLaunch);
            },
          ),
          listTile(
            Icons.logout,
            'Logout',
            () async {
              await FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return SignIn();
                  })));
            },
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'Contact Support',
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Call us: +91 9587691547',
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Mail: anilg@iitk.ac.in',
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> share() async {
  await FlutterShare.share(
      title: 'Example share',
      text: 'Example share text',
      linkUrl: 'https://flutter.dev/',
      chooserTitle: 'Example Chooser Title');
}
Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
