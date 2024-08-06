import 'package:flutter/material.dart';
import '../model/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(product.imageUrl,
            width: 50, height: 50, fit: BoxFit.cover),
        title: Text(product.name),
        subtitle: Text('${product.price} TL'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(product.deliveryArea),
            Text(product.deliveryTime),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/product_detail',
            arguments: product,
          );
        },
      ),
    );
  }
}
