import 'package:firebase_auth/firebase_auth.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import '../model/order.dart';
import '../model/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  Stream<List<Review>> getReviewsForProduct(String productId) {
    return FirebaseFirestore.instance
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Review.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception(StringConstant.userNotLoggedIn);
      }

      final reviewDoc =
          await _firestore.collection('reviews').doc(reviewId).get();

      if (!reviewDoc.exists) {
        throw Exception(StringConstant.noCommentsFound);
      }

      final reviewData = reviewDoc.data() as Map<String, dynamic>;
      final reviewOwnerId = reviewData['customerId'] as String;

      if (currentUser.uid != reviewOwnerId) {
        throw Exception(StringConstant.notAuthorizedDeleteThisComment);
      }

      await _firestore.collection('reviews').doc(reviewId).delete();
    } catch (e) {
      print('Error deleting review: $e');
      rethrow;
    }
  }
}
