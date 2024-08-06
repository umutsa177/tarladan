import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewModel/product_viewmodel.dart';
import '../../../widgets/product_card.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ürünler')),
      body: FutureBuilder(
        future: productViewModel.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: productViewModel.products.length,
            itemBuilder: (context, index) {
              final product = productViewModel.products[index];
              return ProductCard(product: product);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_product');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
