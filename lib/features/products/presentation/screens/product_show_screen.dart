import 'package:flutter/material.dart';

class ProductShowScreen extends StatelessWidget {
  final String productId;
  const ProductShowScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Usuario no admin'),
      ),
    );
  }
}