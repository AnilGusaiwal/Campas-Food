import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:zometo/config/colors.dart';
import 'package:zometo/previwsOrders.dart';
import 'package:zometo/providers/product_provider.dart';
import 'package:zometo/providers/review_card_provider.dart';
import 'package:zometo/providers/user_provider.dart';
import 'package:zometo/splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider()),
        ChangeNotifierProvider<ReviewCardProvider>(
            create: (context) => ReviewCardProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: primaryColor,
            scaffoldBackgroundColor: scaffoldBackgroundColor),
        debugShowCheckedModeBanner: false,
        // home:SignIn(),
           home: SplashScreen(),
           routes: {
       
        "/MyOrders": (ctx) => MyOrders(),
      },

      ),
    );
  }
}
