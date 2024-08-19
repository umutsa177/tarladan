import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import '../../viewModel/auth_viewmodel.dart';
import '../../viewModel/order_viewmodel.dart';
import '../../model/product.dart';
import '../../service/product_service.dart';
import '../../widgets/order_listtile.dart';

class OrderListView extends StatefulWidget {
  const OrderListView({super.key});

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  late Future<void> _ordersFuture;
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final orderViewModel = Provider.of<OrderViewModel>(context, listen: false);
    await orderViewModel.fetchOrders(authViewModel.currentUser!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(StringConstant.myOrders)),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Consumer<OrderViewModel>(
            builder: (context, orderViewModel, child) {
              if (orderViewModel.orders.isEmpty) {
                return const Center(child: Text(StringConstant.noOrdersYet));
              }
              return ListView.builder(
                itemCount: orderViewModel.orders.length,
                itemBuilder: (context, index) {
                  final order = orderViewModel.orders[index];
                  return FutureBuilder<Product?>(
                    future: _productService.getProduct(order.productId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const OrderListTile(
                          title: StringConstant.loading,
                          status: '',
                          price: '',
                        );
                      }
                      if (snapshot.hasError || !snapshot.hasData) {
                        return OrderListTile(
                          title: 'Ürün #${order.productId}',
                          status: order.status,
                          price: '${order.totalPrice} TL',
                          onTap: () => _navigateToOrderDetail(context, order),
                        );
                      }
                      final product = snapshot.data!;
                      return OrderListTile(
                        title: product.name,
                        status: order.status,
                        price: '${order.totalPrice} TL',
                        onTap: () => _navigateToOrderDetail(context, order),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToOrderDetail(BuildContext context, dynamic order) {
    Navigator.pushNamed(
      context,
      '/order_detail',
      arguments: order,
    );
  }
}
