// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'config/colors.dart';

// enum SinginCharactor { fill, outline }

// class Product_Overview extends StatefulWidget {
//   final String productName;
//   final String productImage;
//   final int productPrice;

//   Product_Overview({required this.productImage, required this.productName, required this.productPrice});

//   @override
//   State<Product_Overview> createState() => _Product_OverviewState();
// }

// class _Product_OverviewState extends State<Product_Overview> {
//   SinginCharactor _charactor = SinginCharactor.outline;

//   Widget bonntonNavigatorBar({
//     required Color iconcolor,
//     required Color backgroungColor,
//     required Color color,
//     required String title,
//     required IconData iconData,
//   }) {
//     return Expanded(
//         child: Container(
//       padding: EdgeInsets.all(20),
//       color: backgroungColor,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             iconData,
//             size: 17,
//             color: iconcolor,
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           Text(
//             title,
//             style: TextStyle(color: color),
//           ),
//         ],
//       ),
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: Row(
//         children: [
//           bonntonNavigatorBar(
//               iconcolor: Colors.grey,
//               backgroungColor: textColor,
//               color: Colors.white,
//               title: "Add To WishList",
//               iconData: Icons.favorite_outline),
//           bonntonNavigatorBar(
//               iconcolor: Colors.white70,
//               backgroungColor: primaryColor,
//               color: textColor,
//               title: "Go To Card",
//               iconData: Icons.shop_outlined),
//         ],
//       ),
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: textColor),
//         title: Text(
//           "Product Overview",
//           style: TextStyle(color: textColor),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Container(
//               width: double.infinity,
//               child: Column(
//                 children: [
//                   ListTile(
//                     title: Text(widget.productName),
//                     subtitle: Text('₹ ${widget.productPrice}'),
//                   ),
//                   Container(
//                     height: 250,
//                     padding: EdgeInsets.all(40),
//                     child: Image.network(widget.productImage),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     width: double.infinity,
//                     child: Text(
//                       "Available Options",
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                           color: textColor, fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               radius: 3,
//                               backgroundColor: Colors.green[700],
//                             ),
//                             Radio(
//                                 value: SinginCharactor.fill,
//                                 groupValue: _charactor,
//                                 activeColor: Colors.green[700],
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _charactor = SinginCharactor.outline;
//                                   });
//                                 }),
//                           ],
//                         ),
//                         Text('₹ ${widget.productPrice}'),
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 30,
//                             vertical: 10,
//                           ),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.add,
//                                 size: 17,
//                                 color: primaryColor,
//                               ),
//                               Text('ADD'),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.only(bottom: 50, left: 8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "About This Product",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                 ),
//                 Text(
//                   "A product is the item offered for sale. A product can be a service or an item. It can be physical or in virtual or cyber form. Every product is made at a cost and each is sold at a price.",
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
