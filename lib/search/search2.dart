import 'package:flutter/material.dart';
import 'package:zometo/models/product_model.dart';
import 'package:zometo/items/search_items.dart';
import '../config/colors.dart';
import '../providers/product_provider.dart';
import '../review_card.dart';

class Search2 extends StatefulWidget {
   List<ProductModel>? search;
  Search2({ this.search});

  @override
  State<Search2> createState() => _Search2State();
}

class _Search2State extends State<Search2> {
  String query = "";
  searchItem(String query) {
  
   { List<ProductModel> serachFood = widget.search!.where((element) {
      return element.productName.toLowerCase().contains(query);
    }).toList();
    return serachFood;}
  }

    

  @override
  Widget build(BuildContext context) {
    List<ProductModel> _searchItem = searchItem(query);
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Search",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.menu_rounded,
              color: textColor,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Text(
          "  Go \n Card",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Color.fromARGB(255, 183, 255, 0),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Review_Card()));
        },
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Items"),
          ),
          Container(
            height: 52,
            width: 400,
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  query = value.toLowerCase();
                });
              },
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                hintText: "Search for items in the store",
                hintStyle: TextStyle(color: Colors.black38),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.red,
                ),
                filled: true,
                fillColor: Colors.white12,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Color(0xff0d69ff).withOpacity(1.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Color(0xff0d69ff).withOpacity(1.0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children:_searchItem.map((data)
            {
              return SearchItems(
                productImage: data.productImage,
                productName: data.productName,
                productPrice: data.productPrice,
                productId: data.productId,
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
