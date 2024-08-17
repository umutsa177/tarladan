import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:tarladan/utility/constants/color_constant.dart';
import '../../viewModel/order_viewmodel.dart';
import '../../model/product.dart';
import '../../widgets/review_card.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  Future<String> _getSellerName(String sellerId) async {
    try {
      DocumentSnapshot sellerDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(sellerId)
          .get();

      if (sellerDoc.exists) {
        Map<String, dynamic> sellerData =
            sellerDoc.data() as Map<String, dynamic>;
        return sellerData['name'] ?? 'İsimsiz Satıcı';
      } else {
        return 'Bilinmeyen Satıcı';
      }
    } catch (e) {
      print('Satıcı adı alınırken hata oluştu: $e');
      return 'Satıcı Bilgisi Alınamadı';
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as Product?;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hata'), centerTitle: true),
        body: const Center(child: Text('Ürün bilgisi bulunamadı.')),
      );
    }

    final orderViewModel = Provider.of<OrderViewModel>(context);

    return Scaffold(
      appBar: _appBar(product, context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(product.imageUrl,
                  height: 250, width: 250, fit: BoxFit.cover),
            ),
            context.sized.emptySizedHeightBoxLow,
            Padding(
              padding: context.padding.horizontalNormal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder<String>(
                        future: _getSellerName(product.sellerId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          return Text(
                            "Satıcı: ${snapshot.data ?? 'Yükleniyor...'}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: ColorConstant.grey),
                          );
                        },
                      ),
                      const Icon(
                        Icons.star_outlined,
                        color: ColorConstant.coral,
                      ),
                    ],
                  ),
                  context.sized.emptySizedHeightBoxLow,
                  Text(product.description),
                  context.sized.emptySizedHeightBoxLow,
                  Text('Teslimat Alanı: ${product.deliveryArea}'),
                  context.sized.emptySizedHeightBoxLow,
                  Text('Teslimat Süresi: ${product.deliveryTime} gün'),
                  context.sized.emptySizedHeightBoxLow,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Fiyat
                      Text(
                        '${product.price} TL',
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      // Miktar ayarlama
                      Container(
                        height: context.sized.lowValue,
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorConstant.black),
                          borderRadius: context.border.highBorderRadius,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _decrementQuantity,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: _incrementQuantity,
                            ),
                          ],
                        ),
                      ),
                      // Satın al butonu
                      ElevatedButton(
                        onPressed: () {
                          // Satın alma işlemi
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstant.green,
                          fixedSize: Size.fromWidth(context.sized.width / 3.5),
                        ),
                        child: const Text(
                          'Satın Al',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
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
                      } else {
                        return const Center(child: Text('Henüz yorum yok.'));
                      }
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

  AppBar _appBar(Product product, BuildContext context) {
    return AppBar(
      title: Text(product.name),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
          onPressed: () => context.route.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded)),
    );
  }
}
