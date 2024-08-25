import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerOrder {
  final String id;
  final String customerId;
  final String productId;
  String status;
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

  CustomerOrder copyWith({
    String? id,
    String? customerId,
    String? productId,
    String? status,
    DateTime? createdAt,
    int? quantity,
    double? totalPrice,
  }) {
    return CustomerOrder(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      productId: productId ?? this.productId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
