import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:tarladan/model/order.dart';
import 'package:tarladan/model/product.dart';
import 'package:tarladan/utility/constants/color_constant.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import 'package:tarladan/viewModel/order_viewmodel.dart';

import '../viewModel/auth_viewmodel.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final orderViewModel = Provider.of<OrderViewModel>(context, listen: false);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: context.border.normalBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: context.border.normalRadius,
              ),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: context.padding.onlyLeftLow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("${product.amount} Kg",
                    style: const TextStyle(
                        fontSize: 12, color: ColorConstant.grey)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${product.price.toStringAsFixed(2)} TL',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () async {
                        final String userId =
                            Provider.of<AuthViewModel>(context, listen: false)
                                .currentUser!
                                .id;
                        final order = CustomerOrder(
                          id: '', // Firestore bunu oluşturacak
                          customerId: userId,
                          productId: product.id,
                          status: StringConstant.pending,
                          createdAt: DateTime.now(),
                          quantity: 1,
                          totalPrice: product.price,
                        );
                        await orderViewModel.createOrder(order);
                        ScaffoldMessenger.of(context).showSnackBar(
                          snackBarAnimationStyle: AnimationStyle(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInCubic,
                          ),
                          SnackBar(
                            backgroundColor: ColorConstant.greenAccent,
                            content: Text(
                              '${product.name} siparişlere eklendi',
                              style:
                                  const TextStyle(color: ColorConstant.white),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add_box_rounded,
                        color: ColorConstant.green,
                        size: 42,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
