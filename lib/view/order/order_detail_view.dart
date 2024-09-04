import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:tarladan/utility/constants/color_constant.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import 'package:tarladan/utility/enums/double_constant.dart';
import 'package:tarladan/utility/enums/fontsize_constant.dart';
import 'package:tarladan/utility/enums/fontweight_constant.dart';
import 'package:tarladan/utility/enums/icon_constant.dart';
import 'package:tarladan/utility/enums/icon_size.dart';
import '../../model/order.dart';
import '../../model/product.dart';
import '../../model/review.dart';
import '../../service/product_service.dart';
import '../../service/order_service.dart';

class OrderDetailView extends StatefulWidget {
  final CustomerOrder order;

  const OrderDetailView({super.key, required this.order});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  final ProductService productService = ProductService();
  final OrderService orderService = OrderService();
  late CustomerOrder _order;
  double _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  Future<void> _updateOrderStatus() async {
    try {
      await orderService.updateOrderStatus(_order.id, StringConstant.completed);
      setState(() {
        _order.status = StringConstant.completed;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(StringConstant.orderStatusUpdated)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
    }
  }

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(StringConstant.pleaseSelectAStar)),
      );
      return;
    }

    try {
      Review review = Review(
        id: '',
        orderId: _order.id,
        productId: _order.productId,
        customerId: _order.customerId,
        rating: _rating,
        comment: _reviewController.text,
        createdAt: DateTime.now(),
      );

      await orderService.addReview(review);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(StringConstant.evaluationSuccesfullySaved)),
      );

      _reviewController.clear();
      setState(() {
        _rating = 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: FutureBuilder<Product?>(
        future: productService.getProduct(_order.productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                  height: context.sized.width / 1.5,
                  width: context.sized.width / 1.5,
                  child: IconConstant.loadingBar.toLottie),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text(StringConstant.productNotFound));
          }

          Product product = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: context.padding.normal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: _orderImage(context, product),
                  ),
                  SizedBox(height: context.sized.normalValue),
                  _orderIdText(),
                  SizedBox(height: context.sized.normalValue),
                  _buildInfoRow(StringConstant.product, product.name),
                  _buildInfoRow(
                      StringConstant.amountOrder, _order.quantity.toString()),
                  _buildInfoRow(StringConstant.totalPrice,
                      '₺${_order.totalPrice.toStringAsFixed(2)}'),
                  _buildInfoRow(StringConstant.status, _order.status),
                  _buildInfoRow(
                      StringConstant.orderDate, _order.createdAt.toString()),
                  SizedBox(height: context.sized.normalValue),
                  _deliveryInfoText(),
                  context.sized.emptySizedHeightBoxLow,
                  _buildInfoRow(StringConstant.region, product.deliveryArea),
                  _buildInfoRow(StringConstant.estimatedDeliveryTime,
                      product.deliveryTime.toString()),
                  if (_order.status == StringConstant.pending)
                    Padding(
                      padding: context.padding.onlyTopNormal,
                      child: _buyButton(),
                    ),
                  if (_order.status == StringConstant.completed)
                    _buildReviewSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Center _buyButton() {
    return Center(
      child: ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(ColorConstant.green),
        ),
        onPressed: _updateOrderStatus,
        child: const Text(StringConstant.buy),
      ),
    );
  }

  Text _deliveryInfoText() {
    return Text(
      StringConstant.deliveryInfo,
      style: TextStyle(
        fontSize: FontSizeConstant.eightteen.value,
        fontWeight: FontWeightConstant.bold.value,
      ),
    );
  }

  Text _orderIdText() {
    return Text(
      '${StringConstant.orderID}: ${_order.id}',
      style: TextStyle(
        fontSize: FontSizeConstant.eightteen.value,
        fontWeight: FontWeightConstant.bold.value,
      ),
    );
  }

  Container _orderImage(BuildContext context, Product product) {
    return Container(
      width: DoubleConstant.animationSize.value,
      height: DoubleConstant.animationSize.value,
      decoration: BoxDecoration(
        borderRadius: context.border.normalBorderRadius,
        image: DecorationImage(
          image: NetworkImage(product.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.sized.normalValue),
        Text(
          StringConstant.evaluateProduct,
          style: TextStyle(
            fontSize: FontSizeConstant.eightteen.value,
            fontWeight: FontWeightConstant.bold.value,
          ),
        ),
        SizedBox(height: context.sized.lowValue),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(DoubleConstant.five.value.toInt(), (index) {
            return IconButton(
              icon: Icon(
                index < _rating ? Icons.star : Icons.star_border,
                color: ColorConstant.amber,
                size: IconSize.lowIconSize.value,
              ),
              onPressed: () {
                setState(() {
                  _rating = index + 1;
                });
              },
            );
          }),
        ),
        SizedBox(height: context.sized.normalValue),
        TextField(
          controller: _reviewController,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            hintText: StringConstant.writeYourComment,
            border: OutlineInputBorder(),
          ),
          maxLines: DoubleConstant.maxLines.value.toInt(),
        ),
        SizedBox(height: context.sized.normalValue),
        Center(
          child: ElevatedButton(
            onPressed: _submitReview,
            child: const Text(StringConstant.send),
          ),
        ),
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text(StringConstant.orderDetail),
      automaticallyImplyLeading: false,
      leading: IconButton(
          onPressed: () => context.route.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded)),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: context.padding.verticalLow / 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.sized.width / 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: FontSizeConstant.sixteen.value,
                fontWeight: FontWeightConstant.bold.value,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: FontSizeConstant.sixteen.value),
            ),
          ),
        ],
      ),
    );
  }
}
