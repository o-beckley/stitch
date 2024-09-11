import 'package:flutter/material.dart';
import 'package:stitch/models/product_model.dart';

class ProductScreen extends StatefulWidget {
  final Product product;

  const ProductScreen({
    required this.product,
    super.key
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
