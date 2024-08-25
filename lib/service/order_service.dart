import '../model/order.dart';
import '../model/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CustomerOrder>> getOrders(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .where('customerId', isEqualTo: userId)
          .get();
      return snapshot.docs
          .map((doc) =>
              CustomerOrder.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Sipariş getirme hatası: ${e.toString()}');
      return [];
    }
  }

  Future<void> createOrder(CustomerOrder order) async {
    try {
      await _firestore.collection('orders').add(order.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
    } catch (e) {
      print('Error deleting order: $e');
      rethrow;
    }
  }

  Future<void> addReview(Review review) async {
    try {
      await _firestore.collection('reviews').add(review.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Review>> getReviewsForProduct(String productId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('reviews')
          .where('productId', isEqualTo: productId)
          .get();
      return snapshot.docs
          .map((doc) =>
              Review.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
