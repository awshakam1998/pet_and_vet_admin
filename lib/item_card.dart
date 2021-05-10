import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_and_vet_admin/model/product.dart';


class ItemCard extends StatefulWidget {
  final Product product;
  final bool isCart;

  const ItemCard({Key key, this.product, this.isCart}) : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {

  final databaseReference = FirebaseDatabase.instance.reference();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: NetworkImage( '${widget.product.image}',),
                        fit: BoxFit.cover,
                      )
                  ),

                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        widget.product.name,
                        textAlign: TextAlign.center,
                      ),
                      Text('${widget.product.price} jd'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () async {
                        databaseReference.child('4').child('data').child(widget.product.productId).remove().then((value){
                          print('done');
                        });
                      },
                      child:Icon(Icons.delete_forever)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
