import 'package:flutter/foundation.dart';
import '../service/product_service.dart';
import '../model/product.dart';
import 'auth_viewmodel.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final AuthViewModel _authViewModel;
  List<Product> _products = [];

  ProductViewModel(this._authViewModel);

  List<Product> get products => _products;

  String? get currentUserId => _authViewModel.currentUser?.id;

  Future<void> fetchProducts() async {
    _products = await _productService.getProducts();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await _productService.addProduct(product);
    await fetchProducts();
  }

  Future<void> updateProduct(Product product) async {
    await _productService.updateProduct(product);
    await fetchProducts();
  }

  Future<void> deleteProduct(String productId) async {
    await _productService.deleteProduct(productId);
    await fetchProducts();
  }
}
