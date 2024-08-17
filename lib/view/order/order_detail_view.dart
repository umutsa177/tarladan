import 'package:flutter/material.dart';
import '../../model/order.dart';
import '../../model/product.dart';
import '../../service/product_service.dart';

class OrderDetailView extends StatelessWidget {
  final CustomerOrder order;
  final ProductService productService = ProductService();

  OrderDetailView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sipariş Detayı'),
        centerTitle: true,
      ),
      body: FutureBuilder<Product?>(
        future: productService.getProduct(order.productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Ürün bulunamadı'));
          }

          Product product = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sipariş ID: ${order.id}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Ürün: ${product.name}',
                    style: const TextStyle(fontSize: 16)),
                Text('Miktar: ${order.quantity}',
                    style: const TextStyle(fontSize: 16)),
                Text('Toplam Fiyat: ₺${order.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16)),
                Text('Durum: ${order.status}',
                    style: const TextStyle(fontSize: 16)),
                Text('Sipariş Tarihi: ${order.createdAt.toString()}',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                const Text('Teslimat Bilgileri:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Bölge: ${product.deliveryArea}',
                    style: const TextStyle(fontSize: 16)),
                Text('Tahmini Teslimat Süresi: ${product.deliveryTime}',
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }
}
