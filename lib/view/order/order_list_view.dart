import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/auth_viewmodel.dart';
import '../../viewModel/order_viewmodel.dart';

class OrderListView extends StatelessWidget {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderViewModel = Provider.of<OrderViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Siparişlerim'), centerTitle: true),
      body: FutureBuilder(
        future: orderViewModel.fetchOrders(authViewModel.currentUser!.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: orderViewModel.orders.length,
            itemBuilder: (context, index) {
              final order = orderViewModel.orders[index];
              return ListTile(
                title: Text('Sipariş #${order.id}'),
                subtitle: Text('Durum: ${order.status}'),
                trailing: Text('${order.totalPrice} TL'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/order_detail',
                    arguments: order,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
