// import 'package:flutter/material.dart';
// import 'database_manager.dart';

// class MyHomePage extends StatefulWidget {

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       body: FutureBuilder(
//         future: FireStoreDataBase().downloadURLExample(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Text(
//               "Something went wrong",
//             );
//           }
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Image.network(
//               snapshot.data.toString(),
//             );
//           }
//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }