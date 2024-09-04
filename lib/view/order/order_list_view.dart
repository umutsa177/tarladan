import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:tarladan/utility/constants/color_constant.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import 'package:tarladan/utility/enums/double_constant.dart';
import 'package:tarladan/utility/enums/icon_constant.dart';
import '../../viewModel/auth_viewmodel.dart';
import '../../viewModel/order_viewmodel.dart';
import '../../model/product.dart';
import '../../service/product_service.dart';
import '../../widgets/order_card.dart';

class OrderListView extends StatefulWidget {
  const OrderListView({super.key});

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late Future<void> _ordersFuture;
  final ProductService _productService = ProductService();
  final List<AnimationController> _animationControllers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ordersFuture = _fetchOrders();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshOrders();
    }
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _ordersFuture = _fetchOrders();
    });
  }

  Future<void> _fetchOrders() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final orderViewModel = Provider.of<OrderViewModel>(context, listen: false);
    await orderViewModel.fetchOrders(authViewModel.currentUser!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: IconConstant.basket.toLottie,
            );
          }
          return Consumer<OrderViewModel>(
            builder: (context, orderViewModel, child) {
              if (orderViewModel.orders.isEmpty) {
                return const Center(child: Text(StringConstant.noOrdersYet));
              }
              return _orderListView(orderViewModel);
            },
          );
        },
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(StringConstant.orders),
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

  ListView _orderListView(OrderViewModel orderViewModel) {
    return ListView.builder(
      itemCount: orderViewModel.orders.length,
      itemBuilder: (context, index) {
        final order = orderViewModel.orders[index];
        final animationController = AnimationController(
          duration: Duration(
              milliseconds: DoubleConstant.millisecondsMedium.value.toInt()),
          vsync: this,
        );
        _animationControllers.add(animationController);
        animationController.forward();
        return Dismissible(
          key: Key(order.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: ColorConstant.red,
            alignment: Alignment.centerRight,
            padding: context.padding.onlyRightNormal,
            child: const Icon(
              Icons.delete,
              color: ColorConstant.white,
            ),
          ),
          onDismissed: (direction) {
            _deleteWithAnimation(index, animationController);
          },
          confirmDismiss: (direction) async {
            return await _deleteOrderDialog(context);
          },
          child: FadeTransition(
            opacity: animationController,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(DoubleConstant.offsetdx.value,
                    DoubleConstant.offsetdy.value),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animationController,
                curve: Curves.easeOut,
              )),
              child: FutureBuilder<Product?>(
                future: _productService.getProduct(order.productId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return OrderCard(
                      orderId: order.id,
                      title: StringConstant.loading,
                      status: '',
                      price: '',
                    );
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return OrderCard(
                      orderId: order.id,
                      title: '${StringConstant.product} #${order.productId}',
                      status: order.status,
                      price: '${order.totalPrice} TL',
                      onTap: () => _navigateToOrderDetail(context, order),
                    );
                  }
                  final product = snapshot.data!;
                  return OrderCard(
                    orderId: order.id,
                    title: product.name,
                    status: order.status,
                    price: '${order.totalPrice} TL',
                    onTap: () => _navigateToOrderDetail(context, order),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _deleteOrderDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(StringConstant.deleteOrder),
          content: const Text(StringConstant.areYouSureDeleteThisOrder),
          actions: [
            TextButton(
              child: const Text(StringConstant.cancel),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text(
                StringConstant.delete,
                style: TextStyle(color: ColorConstant.red),
              ),
              onPressed: () => context.route.pop(true),
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToOrderDetail(
      BuildContext context, dynamic order) async {
    context.route.navigateName('/order_detail', data: order);
    _refreshOrders();
  }

  Future<void> _deleteWithAnimation(
      int index, AnimationController controller) async {
    try {
      final orderViewModel =
          Provider.of<OrderViewModel>(context, listen: false);
      final order = orderViewModel.orders[index];

      await controller.reverse();
      await orderViewModel.removeOrder(order.id);

      setState(() {
        _animationControllers.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(StringConstant.orderDeletedSuccessfully)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${StringConstant.orderDeleteError} $e')),
      );
    }
  }
}
