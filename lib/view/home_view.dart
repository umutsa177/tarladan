import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarladan/model/user.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import 'product/product_list_view.dart';
import 'order/order_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    final List<Widget> views = [
      const ProductListView(),
      if (user != null && !user.isSeller) const OrderListView(),
    ];

    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      body: views[_selectedIndex],
      bottomNavigationBar: user != null && !user.isSeller
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: onItemTapped,
              selectedFontSize: 14,
              unselectedFontSize: 14,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_rounded),
                  label: StringConstant.products,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_basket_rounded),
                  label: StringConstant.orders,
                ),
              ],
            )
          : null,
    );
  }
}
