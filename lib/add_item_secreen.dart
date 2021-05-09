import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:images_picker/images_picker.dart';
import 'package:pet_and_vet_admin/model/product.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String imgUrl = 'http://sad.png';
  String animalType;
  String itemType;
  String name;
  String desc;
  String price;
  int animalId;
  int typeId;
  File _image;
  List<String> animals = <String>['Cat', 'Dog', 'Bird'];
  List<String> types = <String>['Type', 'Food', 'Equipment'];
  List<List<String>> category = [
    ['cats', 'food', 'equipment'],
    ['dogs', 'fooddogs', 'eq_dogs'],
    ['birds', 'foodbirds', 'eq_birds']
  ];

  final databaseReference = FirebaseDatabase.instance.reference();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Future getImage(ImageSource imgSource) async {
      // final pickedFile = await picker.getImage(source: imgSource);
      if (imgSource == ImageSource.gallery) {
        List<Media> res = await ImagesPicker.pick(
          count: 1,
          pickType: PickType.image,
          cropOpt: CropOption(
            aspectRatio: CropAspectRatio.wh3x4,
            cropType: CropType.rect, // currently for android
          ),
        );
        String path;
        if (res != null) {
          print(res[0]?.path);
          setState(() {
            path = res[0]?.path;
            _image = File(path);
          });
        }
      } else {
        List<Media> res = await ImagesPicker.openCamera(
          pickType: PickType.image,
          cropOpt: CropOption(
            aspectRatio: CropAspectRatio.wh3x4,
            cropType: CropType.rect, // currently for android
          ),
        );
        String path;
        if (res != null) {
          print(res[0]?.path);
          setState(() {
            path = res[0]?.path;
            _image = File(path);
          });
        }
      }
    }

    Future<String> uploadImage(BuildContext context) async {
      int productId = DateTime.now().millisecondsSinceEpoch;
      showDialog(
        context: context,
        builder: (context) => Center(
          child: Container(
              height: 35, width: 35, child: CircularProgressIndicator()),
        ),
      );
      if (_image == null) {
        print('no');
        Navigator.pop(context);
      } else {
        print(productId);
        if (_image != null) {
          String fileName = basename(_image.path);
          var imageUrl;

          Reference ref = FirebaseStorage.instance
              .ref()
              .child(productId.toString())
              .child('images')
              .child('products');
          UploadTask uploadTask = ref.putFile(_image);

          uploadTask.whenComplete(() async {
            imageUrl = await ref.getDownloadURL();
            Product product = Product(
              image: imageUrl,
              name: name,
              category: category[animalId][typeId],
              desc: desc,
              price: price,
              productId: productId.toString(),
            );
            print('consult: ${product.category}');
            databaseReference
                .child('4')
                .child('data')
                .child(productId.toString())
                .set(product.toJson())
                .then((value) {
              print('done');
              Navigator.pop(context);
              Navigator.pop(context);
            }).catchError((err) {
              print(err);
              Navigator.pop(context);
            });
            print(imageUrl);
          });
        }
      }
      // var taskSnapshot =
      // await (await uploadTask.onComplete).ref.getDownloadURL();
      // var _url = taskSnapshot.toString();
      // print(_url);
      // setState(() {
      //   url = _url;
      // });
      return null;
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text('Photo from'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.photo_camera,
                                            size: 40,
                                          ),
                                          Flexible(
                                            child: Text(
                                              "Camera",
                                            ),
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        getImage(ImageSource.camera);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    Padding(padding: EdgeInsets.all(8.0)),
                                    GestureDetector(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.image,
                                            size: 40,
                                          ),
                                          Flexible(
                                            child: Text(
                                              "Gallery",
                                            ),
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        getImage(ImageSource.gallery);
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              ));
                        });
                  },
                  child: _image == null
                      ? CachedNetworkImage(
                          imageUrl: imgUrl,
                          placeholder: (context, url) => Column(
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 175,
                                color: Theme.of(context).accentColor,
                              ),
                              Text('Add Photo')
                            ],
                          ),
                          color: Colors.red,
                          errorWidget: (context, url, error) => Icon(
                            Icons.add_photo_alternate,
                            size: 175,
                            color: Theme.of(context).accentColor,
                          ),
                          height: 200,
                          width: double.infinity,
                        )
                      : Image.file(_image),
                ),
                Divider(
                  thickness: 3,
                  height: 3,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new DropdownButton<String>(
                    hint: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Animal Type'),
                      ],
                    ),
                    value: animalType,
                    itemHeight: 60,
                    isExpanded: true,
                    items: animals.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        animalId = animals.indexOf(value);
                        animalType = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new DropdownButton<String>(
                    hint: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Item Type'),
                      ],
                    ),
                    value: itemType,
                    itemHeight: 60,
                    isExpanded: true,
                    items: types.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        typeId = types.indexOf(value);
                        itemType = value;
                      });
                    },
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Name',
                          labelText: 'Name ',
                        ),
                        onSaved: (String value) {
                          name = value;
                        },
                        validator: (String value) {
                          return (value.isEmpty)
                              ? 'Please fill the name'
                              : null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Price',
                          labelText: 'Price',
                        ),
                        onSaved: (String value) {
                          price = value;
                        },
                        validator: (String value) {
                          return (value.isEmpty)
                              ? 'Please fill the Price'
                              : null;
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                    labelText: 'Description',
                  ),
                  onSaved: (String value) {
                    desc = value;
                  },
                  validator: (String value) {
                    return (value.isEmpty)
                        ? 'Please fill the Description'
                        : null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    onPressed: () {
                      formKey.currentState.save();
                      if (formKey.currentState.validate()) {
                        if (animalType == null || itemType == null) {
                          print('error');
                        } else {
                          uploadImage(context);
                        }
                      }
                    },
                    child: Text(
                      'Add Item',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
