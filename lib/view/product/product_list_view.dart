import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:tarladan/service/auth_service.dart';
import 'package:tarladan/utility/constants/color_constant.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import 'package:tarladan/utility/enums/icon_constant.dart';
import 'package:tarladan/widgets/product_card.dart';
import '../../model/product.dart';
import '../../viewModel/product_viewmodel.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Ürünler'),
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
                  child: IconConstant.appIcon.toImage,
                ),
                onTap: () => context.route.navigateName('/profile')),
          ),
        ],
      ),
      body: Consumer<ProductViewModel>(
        builder: (context, productViewModel, child) {
          return FutureBuilder<List<Product>>(
            future: productViewModel.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Bir hata oluştu: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text(StringConstant.noProductYet));
              } else {
                return GridView.builder(
                  padding: context.padding.low / 0.75,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index];
                    return InkWell(
                      onTap: () => context.route.navigateName(
                        '/product_detail',
                        data: product,
                      ),
                      child: ProductCard(product: product),
                    );
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FutureBuilder<bool>(
        future: authService.isUserSeller,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink(); // Yükleme sırasında butonu gizle
          }
          if (snapshot.hasData && snapshot.data == true) {
            return FloatingActionButton(
              child: const Icon(Icons.add, color: ColorConstant.white),
              onPressed: () => context.route.navigateName('/add_product'),
            );
          } else {
            return const SizedBox.shrink(); // Satıcı değilse butonu gösterme
          }
        },
      ),
    );
  }
}
