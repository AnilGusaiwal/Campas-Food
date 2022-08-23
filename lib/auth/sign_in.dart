import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zometo/auth/type.dart';
import 'package:zometo/providers/user_provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late UserProvider userProvider;
  final Uri urlTC =Uri(scheme: 'https', host: 'pages.flycricket.io',path:'neatroot/terms.html' );
   final Uri urlPP =Uri(scheme: 'https', host: 'pages.flycricket.io',path:'neatroot/terms.html' );
  

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/background_image.png')),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 400,
              width: double.infinity,
              //color: Colors.red,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Sign in to contiune",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "NeatRoot",
                    style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.green,
                            offset: Offset(5, 5),
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SignInButton(
                    Buttons.Google,
                    text: "Sign up with Google",
                    onPressed: () {
                      signInWithGoogle().then((value) => Navigator.of(context)
                              .pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                            return Type_userapp(user: value!);
                          })));
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SignInButton(
                    Buttons.Apple,
                    text: "Sign up with Apple",
                    onPressed: () {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "By signing in you are agreeing to you",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: (){
                          _launchInBrowser(urlTC);
                        },
                         child: Text(
                          "T&C",
                          style: TextStyle(color: Color.fromARGB(255, 84, 241, 255), fontSize: 18,),
                      ),
                       ),
                       const Text(
                    "and",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                       TextButton(
                        onPressed: (){
                          _launchInBrowser(urlPP);
                        },
                         child: Text(
                          "Privacy Policy",
                          style: TextStyle(color: Color.fromARGB(255, 84, 241, 255), fontSize: 18,),
                      ),
                       ),
                    ],
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<User?> signInWithGoogle() async {
    // Create a new provider
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
      final User? user =
          (await FirebaseAuth.instance.signInWithPopup(googleProvider)).user;

      // Once signed in, return the UserCredential
      return user;
    } else {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final User? user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      // Once signed in, return the UserCredential
      return user;
    }

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
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
