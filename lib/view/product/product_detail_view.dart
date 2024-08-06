import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/order_viewmodel.dart';
import '../../model/product.dart';
import '../../widgets/review_card.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final orderViewModel = Provider.of<OrderViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imageUrl,
                height: 200, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('${product.price} TL',
                      style:
                          const TextStyle(fontSize: 18, color: Colors.green)),
                  const SizedBox(height: 16),
                  Text('Teslimat Alanı: ${product.deliveryArea}'),
                  Text('Teslimat Süresi: ${product.deliveryTime}'),
                  const SizedBox(height: 24),
                  const Text('Yorumlar',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  FutureBuilder(
                    future: orderViewModel.getReviewsForProduct(product.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasData) {
                        final reviews = snapshot.data!;
                        return Column(
                          children: reviews
                              .map((review) => ReviewCard(review: review))
                              .toList(),
                        );
                      }
                      return const Text('Henüz yorum yok.');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Sipariş oluşturma işlemi
        },
        label: const Text('Sipariş Ver'),
        icon: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
