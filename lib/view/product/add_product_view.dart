import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/product_viewmodel.dart';
import '../../model/product.dart';

class AddProductView extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _deliveryAreaController = TextEditingController();
  final TextEditingController _deliveryTimeController = TextEditingController();

  AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Ürün Adı'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Fiyat'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Görsel URL'),
            ),
            TextField(
              controller: _deliveryAreaController,
              decoration: const InputDecoration(labelText: 'Teslimat Alanı'),
            ),
            TextField(
              controller: _deliveryTimeController,
              decoration: const InputDecoration(labelText: 'Teslimat Süresi'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final newProduct = Product(
                  id: '', // Firebase tarafından otomatik oluşturulacak
                  sellerId: productViewModel.currentUserId ?? '',
                  name: _nameController.text,
                  price: double.parse(_priceController.text),
                  imageUrl: _imageUrlController.text,
                  deliveryArea: _deliveryAreaController.text,
                  deliveryTime: _deliveryTimeController.text,
                );
                await productViewModel.addProduct(newProduct);
                Navigator.of(context).pop();
              },
              child: const Text('Ürün Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
