import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerOrder {
  final String id;
  final String customerId;
  final String productId;
  late final String status;
  final DateTime createdAt;
  final int quantity;
  final double totalPrice;

  CustomerOrder({
    required this.id,
    required this.customerId,
    required this.productId,
    required this.status,
    required this.createdAt,
    required this.quantity,
    required this.totalPrice,
  });

  factory CustomerOrder.fromMap(Map<String, dynamic> data, String id) {
    return CustomerOrder(
      id: id,
      customerId: data['customerId'],
      productId: data['productId'],
      status: data['status'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      quantity: data['quantity'],
      totalPrice: data['totalPrice'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'productId': productId,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }
}
