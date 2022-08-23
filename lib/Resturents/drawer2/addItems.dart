import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zometo/config/colors.dart';

class AddItemsInList extends StatefulWidget {
  TextEditingController productName = TextEditingController();
  TextEditingController productImage = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController collectionName = TextEditingController();

  @override
  _AddItemsInListState createState() => _AddItemsInListState();
}

class _AddItemsInListState extends State<AddItemsInList> {
  Future<void> addUser() {
    String productId = widget.productName.text;
    return FirebaseFirestore.instance
        .collection("Res Product")
        .doc("Hall-5")
        .collection("AllData")
        .doc("CollectionList")
        .collection(widget.collectionName.text)
        .doc(productId)
        .set({
      'productId': productId,
      'productImage': widget.productImage.text, // John Doe
      'productName': widget.productName.text, // Stokes and Sons
      'productPrice': int.parse(widget.productPrice.text), // 42
    }).then((value) => print("Data Add Scuccesful"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text("Add Items",style: TextStyle(color: Colors.black87),),
      ),
      body: Container(
        
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/background_image.png')),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            child: Container(
              margin: EdgeInsets.all(10.0),
              height: 290,
              child: ListView(children: [
                TextField(
                  controller: widget.collectionName,
                  decoration: const InputDecoration(
                    hintText: "Type",
                    icon: Icon(Icons.type_specimen),
                  ),
                ),
                TextField(
                  controller: widget.productName,
                  decoration: const InputDecoration(
                    hintText: "Name",
                    icon: Icon(Icons.person),
                  ),
                ),
                TextField(
                  controller: widget.productImage,
                  decoration: const InputDecoration(
                    hintText: "Link Image",
                    icon: Icon(Icons.link),
                  ),
                ),
                TextField(
                  controller: widget.productPrice,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    hintText: "Price",
                    icon: Icon(Icons.price_check),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                
                OutlinedButton(
                  onPressed: () {
                    if (widget.collectionName.text != null &&
                        widget.productImage.text != null &&
                        widget.productPrice.text != null &&
                        widget.productName.text != null) {
                      addUser();
                    }
                  },
                  child: Text(
                    "Add Data",
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
