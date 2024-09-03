import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import 'package:tarladan/utility/enums/icon_constant.dart';
import 'dart:io';
import '../../viewModel/product_viewmodel.dart';
import '../../model/product.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _price = 0.0;
  String _description = '';
  double _amount = 0.0;
  double _deliveryTime = 0.0;
  String _deliveryArea = '';
  File? _image;

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        padding: context.padding.low,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _getImage,
                child: Container(
                  width: context.sized.width / 2.25,
                  height: context.sized.width / 2.25,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _image != null
                      ? Image.file(_image!, fit: BoxFit.cover)
                      : const Icon(Icons.add_a_photo, size: 50),
                ),
              ),
              SizedBox(height: context.sized.lowValue),
              _productNameTextForm(),
              SizedBox(height: context.sized.lowValue),
              _priceTextForm(),
              SizedBox(height: context.sized.lowValue),
              _descriptionTextForm(),
              SizedBox(height: context.sized.lowValue),
              _amountTextForm(),
              SizedBox(height: context.sized.lowValue),
              _deliveryTimeTextForm(),
              SizedBox(height: context.sized.lowValue),
              _deliveryAreaTextForm(),
              SizedBox(height: context.sized.lowValue),
              _addProductButton(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text(StringConstant.addProduct),
      centerTitle: true,
      leading: IconButton(
          onPressed: () => context.route.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded)),
    );
  }

  ElevatedButton _addProductButton(BuildContext context) {
    return ElevatedButton(
      child: const Text(StringConstant.addProduct),
      onPressed: () async {
        if (_formKey.currentState!.validate() && _image != null) {
          _formKey.currentState!.save();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Center(child: IconConstant.loadingBar.toLottie);
            },
          );
          final product = Product(
            id: '',
            name: _name,
            price: _price,
            description: _description,
            imageUrl: _image?.path ?? '',
            amount: _amount,
            deliveryTime: _deliveryTime,
            deliveryArea: _deliveryArea,
            sellerId: FirebaseAuth.instance.currentUser?.uid ?? '',
          );
          try {
            await Provider.of<ProductViewModel>(context, listen: false)
                .addProduct(product, _image!);
            context.route.pop();
            context.route.navigateName('/product_list_view');
          } catch (e) {
            context.route.pop();
          }
        }
      },
    );
  }

  TextFormField _descriptionTextForm() {
    return TextFormField(
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
          labelText: StringConstant.description, border: OutlineInputBorder()),
      maxLines: 3,
      validator: (value) =>
          value!.isEmpty ? '${StringConstant.description} gerekli' : null,
      onSaved: (value) => _description = value!,
    );
  }

  TextFormField _priceTextForm() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
          labelText: StringConstant.price, border: OutlineInputBorder()),
      keyboardType: TextInputType.number,
      validator: (value) =>
          value!.isEmpty ? '${StringConstant.price} gerekli' : null,
      onSaved: (value) => _price = double.parse(value!),
    );
  }

  TextFormField _productNameTextForm() {
    return TextFormField(
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
          labelText: StringConstant.nameProduct, border: OutlineInputBorder()),
      validator: (value) =>
          value!.isEmpty ? '${StringConstant.nameProduct} gerekli' : null,
      onSaved: (value) => _name = value!,
    );
  }

  TextFormField _amountTextForm() {
    return TextFormField(
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
          labelText: StringConstant.amount, border: OutlineInputBorder()),
      validator: (value) =>
          value!.isEmpty ? '${StringConstant.amount} gerekli' : null,
      onSaved: (value) => _amount = double.parse(value!),
    );
  }

  TextFormField _deliveryTimeTextForm() {
    return TextFormField(
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
          labelText: StringConstant.deliveryTime, border: OutlineInputBorder()),
      validator: (value) =>
          value!.isEmpty ? '${StringConstant.deliveryTime} gerekli' : null,
      onSaved: (value) => _deliveryTime = double.parse(value!),
    );
  }

  TextFormField _deliveryAreaTextForm() {
    return TextFormField(
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: StringConstant.deliveryArea, border: OutlineInputBorder()),
      validator: (value) =>
          value!.isEmpty ? '${StringConstant.deliveryArea} gerekli' : null,
      onSaved: (value) => _deliveryArea = value!,
    );
  }
}
