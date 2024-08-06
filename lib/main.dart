import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/profile/profile_view.dart';
import 'viewModel/auth_viewmodel.dart';
import 'viewModel/product_viewmodel.dart';
import 'viewModel/order_viewmodel.dart';
import 'view/auth/login_view.dart';
import 'view/product/product_list_view.dart';
import 'view/product/add_product_view.dart';
import 'view/order/order_list_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProxyProvider<AuthViewModel, ProductViewModel>(
          create: (context) => ProductViewModel(
              Provider.of<AuthViewModel>(context, listen: false)),
          update: (context, authViewModel, previousProductViewModel) =>
              ProductViewModel(authViewModel),
        ),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
      ],
      child: MaterialApp(
        title: 'Tarladan',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginView(),
          '/home': (context) => const ProductListView(),
          '/add_product': (context) => AddProductView(),
          '/orders': (context) => const OrderListView(),
          '/profile': (context) => const ProfileView(),
        },
      ),
    );
  }
}
