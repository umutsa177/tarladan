import 'package:flutter/foundation.dart';
import '../service/order_service.dart';
import '../model/order.dart';
import '../model/review.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<CustomerOrder> _orders = [];

  List<CustomerOrder> get orders => _orders;

  Future<void> fetchOrders(String userId) async {
    _orders = await _orderService.getOrders(userId);
    notifyListeners();
  }

  Future<void> createOrder(CustomerOrder order) async {
    await _orderService.createOrder(order);
    await fetchOrders(order.customerId);
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _orderService.updateOrderStatus(orderId, status);
    await fetchOrders(_orders.first.customerId);
  }

  Future<void> addReview(Review review) async {
    await _orderService.addReview(review);
    notifyListeners();
  }

  Future<List<Review>> getReviewsForProduct(String productId) async {
    return await _orderService.getReviewsForProduct(productId);
  }
}
