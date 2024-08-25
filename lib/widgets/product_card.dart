import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:tarladan/model/order.dart';
import 'package:tarladan/model/product.dart';
import 'package:tarladan/utility/constants/color_constant.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import 'package:tarladan/viewModel/order_viewmodel.dart';
import 'package:tarladan/viewModel/product_viewmodel.dart';

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
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final productViewModel =
        Provider.of<ProductViewModel>(context, listen: false);

    final isCustomer =
        authViewModel.currentUser?.role == StringConstant.customer;
    final isSeller = authViewModel.currentUser?.role == StringConstant.seller;

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
                    if (isCustomer)
                      IconButton(
                        onPressed: () async {
                          final String userId = authViewModel.currentUser!.id;
                          final order = CustomerOrder(
                            id: '',
                            customerId: userId,
                            productId: product.id,
                            status: StringConstant.pending,
                            createdAt: DateTime.now(),
                            quantity: 1,
                            totalPrice: product.price,
                          );
                          await orderViewModel.createOrder(order);
                          ScaffoldMessenger.of(context).showSnackBar(
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
                    if (isSeller)
                      IconButton(
                        onPressed: () async {
                          try {
                            await productViewModel.deleteProduct(product.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: ColorConstant.red,
                                content: Text(
                                  '${product.name} silindi',
                                  style: const TextStyle(
                                      color: ColorConstant.white),
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: ColorConstant.red,
                                content: Text(
                                  'Ürün silinirken bir hata oluştu: $e',
                                  style: const TextStyle(
                                      color: ColorConstant.white),
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: ColorConstant.red,
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
