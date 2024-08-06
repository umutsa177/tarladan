class Product {
  final String id;
  final String sellerId;
  final String name;
  final double price;
  final String imageUrl;
  final String deliveryArea;
  final String deliveryTime;

  Product({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.deliveryArea,
    required this.deliveryTime,
  });

  factory Product.fromMap(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      sellerId: data['sellerId'],
      name: data['name'],
      price: data['price'],
      imageUrl: data['imageUrl'],
      deliveryArea: data['deliveryArea'],
      deliveryTime: data['deliveryTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'deliveryArea': deliveryArea,
      'deliveryTime': deliveryTime,
    };
  }
}
