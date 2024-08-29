import 'package:json/json.dart';

@JsonCodable()
class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final double amount;
  final String imageUrl;
  final double deliveryTime;
  final String deliveryArea;
  final String sellerId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.amount,
    required this.deliveryTime,
    required this.deliveryArea,
    required this.sellerId,
  });
}
