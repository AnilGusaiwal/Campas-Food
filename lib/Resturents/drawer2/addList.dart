import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zometo/config/colors.dart';

class AddNewList extends StatefulWidget {
  TextEditingController NewListName = TextEditingController();

  @override
  _AddNewListState createState() => _AddNewListState();
}

class _AddNewListState extends State<AddNewList> {
  Future<void> addList() {
    return FirebaseFirestore.instance
        .collection("Res Product")
        .doc("Hall-5")
        .collection("TypeList")
        .doc(widget.NewListName.text)
        .set({
          "num":5000
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text(
          "Add Items",
          style: TextStyle(color: Colors.black87),
        ),
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
              height: 150,
              child: ListView(children: [
                TextField(
                  controller: widget.NewListName,
                  decoration: const InputDecoration(
                    hintText: "New List Name",
                    icon: Icon(Icons.type_specimen),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                OutlinedButton(
                  child: Text('Add List'),
                  onPressed: () {
                    if (widget.NewListName.text != null) {
                      addList();
                    }
                  },
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
