import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:tarladan/model/order.dart';
import 'package:tarladan/model/product.dart';
import 'package:tarladan/utility/constants/color_constant.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import 'package:tarladan/viewModel/order_viewmodel.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../viewModel/auth_viewmodel.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.index,
  });

  final Product product;
  final int index;

  @override
  Widget build(BuildContext context) {
    final orderViewModel = Provider.of<OrderViewModel>(context, listen: false);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    final isCustomer =
        authViewModel.currentUser?.role == StringConstant.customer;

    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 375),
      columnCount: 2,
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: context.border.normalBorderRadius),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: context.border.normalRadius),
                    child: _productImage(),
                  ),
                ),
                Padding(
                  padding: context.padding.onlyLeftLow,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _productNameText(),
                      _productAmountText(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _productPriceText(),
                          if (isCustomer)
                            _addButton(authViewModel, orderViewModel, context),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CachedNetworkImage _productImage() {
    return CachedNetworkImage(
      imageUrl: product.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Text _productNameText() {
    return Text(product.name,
        style: const TextStyle(fontWeight: FontWeight.bold));
  }

  Text _productAmountText() {
    return Text("${product.amount} Kg",
        style: const TextStyle(fontSize: 12, color: ColorConstant.grey));
  }

  Text _productPriceText() {
    return Text('${product.price.toStringAsFixed(2)} TL',
        style: const TextStyle(fontWeight: FontWeight.bold));
  }

  IconButton _addButton(AuthViewModel authViewModel,
      OrderViewModel orderViewModel, BuildContext context) {
    return IconButton(
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
              style: const TextStyle(color: ColorConstant.white),
            ),
          ),
        );
      },
      icon: const Icon(
        Icons.add_box_rounded,
        color: ColorConstant.green,
        size: 42,
      ),
    );
  }
}
