import 'package:flutter/material.dart';
import 'package:zometo/config/colors.dart';
import 'package:zometo/product_overview.dart';
import 'package:zometo/items/count.dart';

import '../auth/sign_in.dart';

class singalProduct extends StatelessWidget {
  final String productImage;
  final String productName;
  final int productPrice;
  final void Function()? onTap;
  final String productid;

  singalProduct(
      {required this.productImage,
      required this.productName,
      required this.productPrice,
      required this.onTap,
      required this.productid});

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      elevation: 2,
      shadowColor: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: 230,
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                height: 90,
                padding: EdgeInsets.all(5),
                width: double.infinity,
                child: Image.network(productImage),
              ),
            ),
            Container(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 18),
                  )
                ],
              ),
            )),
            Text(
              ' ₹ ${productPrice}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Count(
                  productName: productName,
                  productQuantity: 1,
                  productPrice: productPrice,
                  productId: productid,
                  productImage: productImage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
