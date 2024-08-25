import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tarladan/service/auth_service.dart';
import 'package:tarladan/service/product_service.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import 'package:tarladan/utility/initialize/app_theme.dart';
import 'package:tarladan/view/auth/register_view.dart';
import 'package:tarladan/view/home/home_view.dart';
import 'package:tarladan/view/order/order_detail_view.dart';
import 'package:tarladan/view/product/product_detail_view.dart';
import 'model/order.dart';
import 'view/profile/profile_view.dart';
import 'viewModel/auth_viewmodel.dart';
import 'viewModel/product_viewmodel.dart';
import 'viewModel/order_viewmodel.dart';
import 'view/auth/login_view.dart';
import 'view/product/add_product_view.dart';
import 'view/order/order_list_view.dart';
import 'model/user.dart';

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
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ProductService>(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProxyProvider2<AuthViewModel, ProductService,
            ProductViewModel>(
          create: (context) => ProductViewModel(
              Provider.of<AuthViewModel>(context, listen: false),
              Provider.of<ProductService>(context, listen: false)),
          update: (context, authViewModel, productService,
                  previousProductViewModel) =>
              ProductViewModel(authViewModel, productService),
        ),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
        // ChangeNotifierProvider(create: (_) => ReviewViewModel()),
        StreamProvider<AppUser?>.value(
          value: AuthService().user,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: StringConstant.appTitle,
        theme: AppTheme(context).theme,
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginView(),
          '/home': (context) => const HomeView(),
          '/add_product': (context) => const AddProductView(),
          '/orders': (context) => const OrderListView(),
          '/profile': (context) => const ProfileView(),
          '/register': (context) => const RegisterView(),
          '/product_detail': (context) => const ProductDetailView(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/order_detail') {
            final order = settings.arguments as CustomerOrder;
            return MaterialPageRoute(
              builder: (context) => OrderDetailView(order: order),
            );
          }
          return null;
        },
      ),
    );
  }
}
