import 'package:flutter/material.dart';

class Product {
  Product(
      {this.name,
      this.image,
      this.brand,
      this.price,
      this.rating,
      this.description,
      this.totalReviews,
      this.sizes,
      this.colors,
      this.quantity});

  String name;
  String image;
  double rating;
  String price;
  String brand;
  String description;
  int totalReviews;
  List<String> sizes;
  List<ProductColor> colors;
  int quantity = 0;
}

class ProductColor {
  ProductColor({this.colorName, this.color});

  final String colorName;
  final MaterialColor color;
}
