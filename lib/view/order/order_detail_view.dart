import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import '../../model/order.dart';
import '../../model/product.dart';
import '../../service/product_service.dart';
import '../../service/order_service.dart';

class OrderDetailView extends StatefulWidget {
  final CustomerOrder order;

  const OrderDetailView({super.key, required this.order});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  final ProductService productService = ProductService();
  final OrderService orderService =
      OrderService(); // OrderService örneği oluşturun
  late CustomerOrder _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  Future<void> _updateOrderStatus() async {
    try {
      await orderService.updateOrderStatus(_order.id, StringConstant.completed);
      setState(() {
        _order.status = StringConstant.completed;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sipariş durumu güncellendi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: FutureBuilder<Product?>(
        future: productService.getProduct(_order.productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Ürün bulunamadı'));
          }

          Product product = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: context.padding.normal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: context.border.normalBorderRadius,
                        image: DecorationImage(
                          image: NetworkImage(product.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Sipariş ID: ${_order.id}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildInfoRow('Ürün', product.name),
                  _buildInfoRow('Miktar', _order.quantity.toString()),
                  _buildInfoRow('Toplam Fiyat',
                      '₺${_order.totalPrice.toStringAsFixed(2)}'),
                  _buildInfoRow('Durum', _order.status),
                  _buildInfoRow('Sipariş Tarihi', _order.createdAt.toString()),
                  const SizedBox(height: 16),
                  const Text('Teslimat Bilgileri:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  _buildInfoRow('Bölge', product.deliveryArea),
                  _buildInfoRow('Tahmini Teslimat Süresi',
                      product.deliveryTime.toString()),
                  if (_order.status == StringConstant.pending)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: _updateOrderStatus,
                        child: const Text('Satın Al'),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text('Sipariş Detayı'),
      automaticallyImplyLeading: false,
      leading: IconButton(
          onPressed: () => context.route.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded)),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
