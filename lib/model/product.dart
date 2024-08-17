class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final double amount;
  final String imageUrl;
  final double deliveryTime;
  final String deliveryArea;
  final String sellerId; // Yeni eklenen alan

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.amount,
    required this.deliveryTime,
    required this.deliveryArea,
    required this.sellerId, // Yeni eklenen alan
  });

  factory Product.fromMap(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      deliveryTime: (data['deliveryTime'] ?? 0).toDouble(),
      deliveryArea: data['deliveryArea'] ?? '',
      sellerId: data['sellerId'] ?? '', // Yeni eklenen alan
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'amount': amount,
      'imageUrl': imageUrl,
      'deliveryTime': deliveryTime,
      'deliveryArea': deliveryArea,
      'sellerId': sellerId, // Yeni eklenen alan
    };
  }
}
