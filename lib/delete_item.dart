import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pet_and_vet_admin/item_card.dart';
import 'package:pet_and_vet_admin/model/product.dart';

class DeleteItem extends StatefulWidget {
  @override
  _DeleteItemState createState() => _DeleteItemState();
}

class _DeleteItemState extends State<DeleteItem> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Product> products = [];

  getProductsList() async {
    databaseReference.child('4').child('data').onValue.listen((event) {
      List<Product> productList = [];
      print('awsawada ${event.snapshot.value}');
      Map<String, dynamic> snapshot =
          Map<String, dynamic>.from(event.snapshot.value);
      snapshot.forEach((k, map) {
        Product product = Product.fromJson(Map.from(map));
        print(product.desc);
        if (mounted)
          setState(() {
            productList.add(product);
            products=productList;
          });
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    getProductsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Item'),
      ),
      body: products.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) => ItemCard(
                product: products[index],
              ),
              itemCount: products.length,
              shrinkWrap: true,
            ),
    );
  }
}
