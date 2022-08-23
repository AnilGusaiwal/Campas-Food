import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zometo/config/colors.dart';
import 'package:zometo/items/count.dart';

class SearchItems extends StatefulWidget {
  final String productImage;
  final String productName;
  final int productPrice;
  final String productId;
  var productQuantity;

  SearchItems({
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productId,
    this.productQuantity,
  });

  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  bool? buttonclick = false;
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
                height: 100,
                width: 120,
                
                child: Center(
                  child: Image.network(widget.productImage,fit: BoxFit.cover,),
                ),
              ),
          ),
          
          Expanded(
            child: Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productName,
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      Text(
                        "₹ ${widget.productPrice}",
                        style: TextStyle(
                            color: Color.fromARGB(255, 5, 5, 121), fontSize: 17),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Count(
                  productName: widget.productName,
                  productQuantity: 1,
                  productPrice: widget.productPrice,
                  productId: widget.productId,
                  productImage: widget.productImage,
                ),
              
                  
        ],
      ),
    );
  }
}
