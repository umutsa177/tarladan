import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> getProductsForSeller(String sellerId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('sellerId', isEqualTo: sellerId)
          .get();
      return snapshot.docs
          .map((doc) =>
              Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting products for seller: $e');
      return [];
    }
  }

  Future<List<Product>> getAllProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      return snapshot.docs
          .map((doc) =>
              Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting all products: $e');
      return [];
    }
  }

  Future<Product?> getProduct(String productId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _firestore.collection('products').add(product.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Stream<List<Product>> streamProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
