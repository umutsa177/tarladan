import 'package:flutter/foundation.dart';
import '../service/order_service.dart';
import '../model/order.dart';
import '../model/review.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<CustomerOrder> _orders = [];

  List<CustomerOrder> get orders => _orders;

  Future<void> fetchOrders(String userId) async {
    try {
      _orders = await _orderService.getOrders(userId);
      notifyListeners();
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  Future<void> removeOrder(String orderId) async {
    try {
      await _orderService.deleteOrder(orderId);
      _orders.removeWhere((order) => order.id == orderId);
      notifyListeners();
    } catch (e) {
      print('Error removing order: $e');
      rethrow;
    }
  }

  Future<void> createOrder(CustomerOrder order) async {
    await _orderService.createOrder(order);
    await fetchOrders(order.customerId);
  }

  Future<void> updateOrder(String orderId, String newStatus) async {
    try {
      await _orderService.updateOrderStatus(orderId, newStatus);
      int index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(status: newStatus);
        notifyListeners();
      }
    } catch (e) {
      print('Error updating order: $e');
      rethrow;
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _orderService.updateOrderStatus(orderId, status);
    await fetchOrders(_orders.first.customerId);
  }

  Future<void> addReview(Review review) async {
    await _orderService.addReview(review);
    notifyListeners();
  }

  Stream<List<Review>> getReviewsForProduct(String productId) {
    return _orderService.getReviewsForProduct(productId);
  }

  Future<void> deleteReview(String reviewId) async {
    return await _orderService.deleteReview(reviewId);
  }
}
