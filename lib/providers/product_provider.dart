import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  late ProductModel productModel;

 ProductModel productModels(DocumentSnapshot element) {
   return ProductModel(
      productImage: element["productImage"],
      productName: element["productName"],
      productPrice: element["productPrice"],
      productId: element["productId"],
    );
  }

  // /////////////// herbsProduct ///////////////////////////////
  // List<ProductModel> herbsProductList = [];

  // fatchHerbsProductData() async {
  //   List<ProductModel> newList = [];

  //   QuerySnapshot value =
  //       await FirebaseFirestore.instance.collection("HerbsProduct").get();

  //   value.docs.forEach(
  //     (element) {
  //       productModels(element);

  //       newList.add(productModel);
  //     },
  //   );
  //   herbsProductList = newList;
  //   notifyListeners();
  // }

  // List<ProductModel> get getHerbsProductDataList {
  //   return herbsProductList;
  // }

  // /////////////// FreshProduct ///////////////////////////////
  // List<ProductModel> freshProductList = [];

  // fatchFreshProductData() async {
  //   List<ProductModel> newList = [];

  //   QuerySnapshot value =
  //       await FirebaseFirestore.instance.collection("FreshProduct").get();

  //   value.docs.forEach(
  //     (element) {
  //       productModels(element);

  //       newList.add(productModel);
  //     },
  //   );
  //   freshProductList = newList;
  //   notifyListeners();
  // }

  // List<ProductModel> get getfreshProductDataList {
  //   return freshProductList;
  // }

  // /////////////////////////Chichen Biryani/////////////////////
  // List<ProductModel> biryaniList = [];

  // fatchBiryaniData() async {
  //   List<ProductModel> newList = [];

  //   QuerySnapshot value =
  //       await FirebaseFirestore.instance.collection("Chicken Biryani").get();

  //   value.docs.forEach(
  //     (element) {
  //       productModels(element);

  //       newList.add(productModel);
  //     },
  //   );
  //   biryaniList = newList;
  //   notifyListeners();
  // }

  // List<ProductModel> get getBiryaniDataList {
  //   return biryaniList;
  // }

  ///////////Same Tpye Product Data list//////
  ///
   Map<String, List<ProductModel>> competeListMap=HashMap();
  List<ProductModel> search2 = [];
  getSameAllProduct() {
    List<ProductModel> tpyeList = [];
    FirebaseFirestore.instance
        .collection("Res Product")
        .doc("Hall-5")
        .collection("TypeList")
        .get()
        .then((value) => value.docs.forEach((element) {
              FirebaseFirestore.instance
                  .collection("Res Product")
                  .doc("Hall-5")
                  .collection("AllData")
                  .doc("CollectionList")
                  .collection(element.id)
                  .get( )
                  .then((value) => 
                  value.docs.forEach((element2) {
                     
                        search2.add(productModels(element2));
                        tpyeList.add(productModels(element2));
                      }));
              competeListMap[element.id] = tpyeList;
              tpyeList.clear();
            }));
    notifyListeners();
  }

  Map<String, List<ProductModel>> get getMapAllProductDataList {
    return competeListMap;
  }

  List<ProductModel> get getAllProductDataList {
    return search2;
  }
}
