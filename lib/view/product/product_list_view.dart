import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:tarladan/service/auth_service.dart';
import 'package:tarladan/utility/constants/color_constant.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import 'package:tarladan/utility/enums/double_constant.dart';
import 'package:tarladan/utility/enums/icon_constant.dart';
import 'package:tarladan/viewModel/auth_viewmodel.dart';
import 'package:tarladan/widgets/product_card.dart';
import '../../model/product.dart';
import '../../viewModel/product_viewmodel.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    final isSeller = authViewModel.currentUser?.role == StringConstant.seller;

    return Scaffold(
      appBar: _appBar(context),
      body: Consumer<ProductViewModel>(
        builder: (context, productViewModel, child) {
          return FutureBuilder<List<Product>>(
            future: productViewModel.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                      height: context.sized.width / 1.5,
                      width: context.sized.width / 1.5,
                      child: IconConstant.shopping.toLottie),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                      '${StringConstant.anErrorOccurred}: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text(StringConstant.noProductYet));
              } else {
                return _productGridView(
                    context, snapshot, isSeller, productViewModel);
              }
            },
          );
        },
      ),
      floatingActionButton: _fabButton(authService),
    );
  }

  AnimationLimiter _productGridView(
      BuildContext context,
      AsyncSnapshot<List<Product>> snapshot,
      bool isSeller,
      ProductViewModel productViewModel) {
    return AnimationLimiter(
      child: GridView.builder(
        padding: context.padding.low / 0.75,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: DoubleConstant.crossAxisCount.value.toInt(),
          childAspectRatio: DoubleConstant.childAspectRatio.value,
          crossAxisSpacing: DoubleConstant.ten.value,
          mainAxisSpacing: DoubleConstant.ten.value,
        ),
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final product = snapshot.data![index];
          return InkWell(
            onTap: () => context.route.navigateName(
              '/product_detail',
              data: product,
            ),
            onLongPress: isSeller
                ? () async {
                    final bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return _deleteProductDialog(product, context);
                      },
                    );
                    if (confirm == true) {
                      try {
                        await productViewModel.deleteProduct(product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: ColorConstant.red,
                            content: Text(
                              '${product.name} silindi',
                            ),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: ColorConstant.red,
                            content: Text(
                              '${StringConstant.productDeleteError}: $e',
                            ),
                          ),
                        );
                      }
                    }
                  }
                : null,
            child: ProductCard(product: product, index: index),
          );
        },
      ),
    );
  }

  AlertDialog _deleteProductDialog(Product product, BuildContext context) {
    return AlertDialog(
      title: const Text(StringConstant.deleteProduct),
      content:
          Text('${product.name} ürününü silmek istediğinizden emin misiniz?'),
      actions: [
        TextButton(
          child: const Text(StringConstant.cancel),
          onPressed: () => context.route.pop(false),
        ),
        TextButton(
          child: const Text(StringConstant.delete),
          onPressed: () => context.route.pop(true),
        ),
      ],
    );
  }

  FutureBuilder<bool> _fabButton(AuthService authService) {
    return FutureBuilder<bool>(
      future: authService.isUserSeller,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasData && snapshot.data == true) {
          return FloatingActionButton(
            child: const Icon(Icons.add, color: ColorConstant.white),
            onPressed: () => context.route.navigateName('/add_product'),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(StringConstant.products),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      actions: [
        Padding(
          padding: context.padding.horizontalNormal,
          child: InkWell(
              child: CircleAvatar(
                backgroundColor: ColorConstant.greyShade300,
                child: IconConstant.userIcon.toImage,
              ),
              onTap: () => context.route.navigateName('/profile')),
        ),
      ],
    );
  }
}
