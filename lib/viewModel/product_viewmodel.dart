import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../model/product.dart';
import '../service/product_service.dart';
import 'auth_viewmodel.dart';

class ProductViewModel extends ChangeNotifier {
  final AuthViewModel _authViewModel;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ProductService _productService;

  ProductViewModel(this._authViewModel, this._productService);

  Future<void> addProduct(Product product, File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('product_images/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      await _firestore.collection('products').add({
        ...product.toMap(),
        'imageUrl': imageUrl,
        'sellerId': _authViewModel.currentUser?.id,
      });
      notifyListeners();
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      return await _productService.getProducts();
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _productService.deleteProduct(productId);
      notifyListeners();
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }
}
