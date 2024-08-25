import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:tarladan/utility/constants/color_constant.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import '../../model/order.dart';
import '../../viewModel/auth_viewmodel.dart';
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
        return sellerData['name'] ?? StringConstant.noNameSeller;
      } else {
        return StringConstant.unknownSeller;
      }
    } catch (e) {
      print('${StringConstant.sellerNameError}: $e');
      return StringConstant.noSellerInfo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as Product?;
    final orderViewModel = Provider.of<OrderViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    // Kullanıcının rolünü kontrol et
    final isCustomer =
        authViewModel.currentUser?.role == StringConstant.customer;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(StringConstant.error)),
        body: const Center(child: Text(StringConstant.noProductInfo)),
      );
    }

    return Scaffold(
      appBar: _appBar(product, context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: context.border.normalBorderRadius,
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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
                            "${StringConstant.seller}: ${snapshot.data ?? StringConstant.loading}",
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
                  Text(
                      '${StringConstant.deliveryArea}: ${product.deliveryArea}'),
                  context.sized.emptySizedHeightBoxLow,
                  Text(
                      '${StringConstant.noDateDeliveryTime}: ${product.deliveryTime} gün'),
                  context.sized.emptySizedHeightBoxLow,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _priceText(product),
                      if (isCustomer) _incrementAndDecrementButton(context),
                      if (isCustomer)
                        _buyButton(context, product, orderViewModel),
                    ],
                  ),
                  context.sized.emptySizedHeightBoxLow,
                  const Text(StringConstant.comments,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                        return const Center(
                            child: Text(StringConstant.noCommentsYet));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text _priceText(Product product) {
    return Text(
      '${product.price} TL',
      style: const TextStyle(
          fontSize: 25,
          color: ColorConstant.black,
          fontWeight: FontWeight.bold),
    );
  }

  ElevatedButton _buyButton(
      BuildContext context, Product product, OrderViewModel orderViewModel) {
    return ElevatedButton(
      onPressed: () async {
        final String userId =
            Provider.of<AuthViewModel>(context, listen: false).currentUser!.id;
        final order = CustomerOrder(
          id: '',
          customerId: userId,
          productId: product.id,
          status: StringConstant.completed,
          createdAt: DateTime.now(),
          quantity: _quantity,
          totalPrice: product.price * _quantity,
        );
        await orderViewModel.createOrder(order);
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarAnimationStyle: AnimationStyle(
            duration: const Duration(seconds: 1),
            curve: Curves.bounceInOut,
          ),
          SnackBar(
            backgroundColor: ColorConstant.greenAccent,
            content: Text(
              '${product.name} başarıyla satın alındı',
              style: const TextStyle(color: ColorConstant.white),
            ),
          ),
        );
        context.route.navigation.pop(); // Önceki ekrana dön
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstant.green,
        fixedSize: Size.fromWidth(context.sized.width / 4.75),
      ),
      child: const Text(
        StringConstant.buy,
        style: TextStyle(fontSize: 12),
      ),
    );
  }

  Container _incrementAndDecrementButton(BuildContext context) {
    return Container(
      height: context.sized.highValue / 2,
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
    );
  }

  AppBar _appBar(Product product, BuildContext context) {
    return AppBar(
      title: Text(product.name),
      automaticallyImplyLeading: false,
      leading: IconButton(
          onPressed: () => context.route.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded)),
    );
  }
}
