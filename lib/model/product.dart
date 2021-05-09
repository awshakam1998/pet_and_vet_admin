// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';

List<Product> productsFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productsToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    this.category,
    this.desc,
    this.image,
    this.name,
    this.price,
    this.productId,
  });

  String category;
  String desc;
  String image;
  String name;
  String price;
  String productId;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    category: json["category"] == null ? null : json["category"],
    desc: json["flag"] == null ? null : json["flag"],
    image: json["image"] == null ? null : json["image"],
    name: json["name"] == null ? null : json["name"],
    price: json["price"] == null ? null : json["price"],
    productId: json["product_id"] == null ? null : json["product_id"],
  );

  Map<String, dynamic> toJson() => {
    "category": category == null ? null : category,
    "flag": desc == null ? null : desc,
    "image": image == null ? null : image,
    "name": name == null ? null : name,
    "price": price == null ? null : price,
    "product_id": productId == null ? null : productId,
  };
}
