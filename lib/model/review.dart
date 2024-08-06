import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String orderId;
  final String customerId;
  final String customerName; // Yeni eklenen alan
  final String productId;
  final int rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.customerName, // Yeni eklenen alan
    required this.productId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> data, String id) {
    return Review(
      id: id,
      orderId: data['orderId'],
      customerId: data['customerId'],
      customerName: data['customerName'], // Yeni eklenen alan
      productId: data['productId'],
      rating: data['rating'],
      comment: data['comment'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'customerName': customerName, // Yeni eklenen alan
      'productId': productId,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
