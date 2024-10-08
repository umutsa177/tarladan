import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:tarladan/utility/constants/color_constant.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import 'package:tarladan/utility/enums/double_constant.dart';
import 'package:tarladan/utility/enums/fontsize_constant.dart';
import 'package:tarladan/utility/enums/fontweight_constant.dart';
import 'package:tarladan/utility/enums/icon_constant.dart';
import '../../model/order.dart';
import '../../viewModel/auth_viewmodel.dart';
import '../../viewModel/order_viewmodel.dart';
import '../../model/product.dart';
import '../../model/review.dart';
import '../../widgets/review_card.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  Future<String> _getSellerName(String sellerId) async {
    try {
      DocumentSnapshot sellerDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(sellerId)
          .get();

      if (sellerDoc.exists) {
        Map<String, dynamic> sellerData =
            sellerDoc.data() as Map<String, dynamic>;
        return sellerData['name'] ?? StringConstant.noNameSeller;
      } else {
        return StringConstant.unknownSeller;
      }
    } catch (e) {
      print('${StringConstant.sellerNameError}: $e');
      return StringConstant.noSellerInfo;
    }
  }

  Future<String> _getCustomerName(String customerId) async {
    try {
      DocumentSnapshot sellerDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(customerId)
          .get();

      if (sellerDoc.exists) {
        Map<String, dynamic> sellerData =
            sellerDoc.data() as Map<String, dynamic>;
        return sellerData['name'] ?? StringConstant.noNameCustomer;
      } else {
        return StringConstant.unknownCustomer;
      }
    } catch (e) {
      print('${StringConstant.customerNameError}: $e');
      return StringConstant.noCustomerInfo;
    }
  }

  Future<double> _getAverageRating(String productId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('productId', isEqualTo: productId)
          .get();

      if (querySnapshot.docs.isEmpty) return 0.0;

      double totalRating = 0.0;
      for (var doc in querySnapshot.docs) {
        totalRating += (doc['rating'] ?? 0.0).toDouble();
      }
      return totalRating / querySnapshot.docs.length;
    } catch (e) {
      print('${StringConstant.ratingError}: $e');
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as Product?;
    final orderViewModel = Provider.of<OrderViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    final isCustomer =
        authViewModel.currentUser?.role == StringConstant.customer;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(StringConstant.error)),
        body: const Center(child: Text(StringConstant.noProductInfo)),
      );
    }

    return Scaffold(
      appBar: _appBar(product, context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _productImage(context, product)),
            context.sized.emptySizedHeightBoxLow,
            Padding(
              padding: context.padding.horizontalNormal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _productNameText(product),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sellerNameText(product),
                      _productAverageRating(product),
                    ],
                  ),
                  context.sized.emptySizedHeightBoxLow,
                  Text(product.description),
                  context.sized.emptySizedHeightBoxLow,
                  _deliveryAreaText(product),
                  context.sized.emptySizedHeightBoxLow,
                  _deliveryTimeText(product),
                  context.sized.emptySizedHeightBoxLow,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _priceText(product),
                      if (isCustomer) _incrementAndDecrementButton(context),
                      if (isCustomer)
                        _buyButton(context, product, orderViewModel),
                    ],
                  ),
                  context.sized.emptySizedHeightBoxLow,
                  _commentsText(),
                  _buildReviewsList(product, orderViewModel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text _productNameText(Product product) {
    return Text(
      product.name,
      style: TextStyle(
        fontWeight: FontWeightConstant.bold.value,
        fontSize: FontSizeConstant.thirty.value,
      ),
    );
  }

  FutureBuilder<String> _sellerNameText(Product product) {
    return FutureBuilder<String>(
      future: _getSellerName(product.sellerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return Text(
          "${StringConstant.seller}: ${snapshot.data ?? StringConstant.loading}",
          style: TextStyle(
            fontWeight: FontWeightConstant.bold.value,
            fontSize: FontSizeConstant.sixteen.value,
            color: ColorConstant.grey,
          ),
        );
      },
    );
  }

  Container _productImage(BuildContext context, Product product) {
    return Container(
      width: DoubleConstant.productSize.value,
      height: DoubleConstant.productSize.value,
      decoration: BoxDecoration(
        borderRadius: context.border.normalBorderRadius,
        image: DecorationImage(
          image: NetworkImage(product.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  FutureBuilder<double> _productAverageRating(Product product) {
    return FutureBuilder<double>(
      future: _getAverageRating(product.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final rating = snapshot.data ?? 0.0;
        return Container(
          height: context.sized.highValue / 2.25,
          width: context.sized.highValue / 1.35,
          decoration: BoxDecoration(
            border: Border.all(color: ColorConstant.greyShade300),
            borderRadius: context.border.highBorderRadius,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.star_outlined,
                color: ColorConstant.coral,
              ),
              Text(
                rating.toStringAsFixed(1),
                style: TextStyle(
                  fontWeight: FontWeightConstant.medium.value,
                  fontSize: FontSizeConstant.sixteen.value,
                  color: ColorConstant.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Text _deliveryAreaText(Product product) {
    return Text(
      '${StringConstant.deliveryArea}: ${product.deliveryArea}',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Text _deliveryTimeText(Product product) {
    return Text(
      '${StringConstant.noDateDeliveryTime}: ${product.deliveryTime} gün',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Text _commentsText() {
    return Text(
      StringConstant.comments,
      style: TextStyle(
        fontSize: FontSizeConstant.twenty.value,
        fontWeight: FontWeightConstant.bold.value,
      ),
    );
  }

  Widget _buildReviewsList(Product product, OrderViewModel orderViewModel) {
    return StreamBuilder<List<Review>>(
      stream: orderViewModel.getReviewsForProduct(product.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: context.sized.width / 2.25,
              width: context.sized.width / 2.25,
              child: IconConstant.loadingBar.toLottie,
            ),
          );
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final reviews = snapshot.data!;
          return AnimationLimiter(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                final currentUserId =
                    Provider.of<AuthViewModel>(context, listen: false)
                        .currentUser
                        ?.id;
                final isReviewOwner = currentUserId == review.customerId;

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(
                      milliseconds: DoubleConstant.milliseconds.value.toInt()),
                  child: SlideAnimation(
                    verticalOffset: DoubleConstant.verticalOffset.value,
                    child: FadeInAnimation(
                      child: isReviewOwner
                          ? Slidable(
                              key: ValueKey(review.id),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                dismissible: DismissiblePane(
                                  onDismissed: () {
                                    _deleteReview(review, orderViewModel);
                                  },
                                ),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      _deleteReview(review, orderViewModel);
                                    },
                                    backgroundColor: ColorConstant.red,
                                    foregroundColor: ColorConstant.white,
                                    icon: Icons.delete,
                                    label: StringConstant.delete,
                                  ),
                                ],
                              ),
                              child: FutureBuilder<String>(
                                future: _getCustomerName(review.customerId),
                                builder: (context, nameSnapshot) {
                                  return ReviewCard(
                                    review: review,
                                    customerName: nameSnapshot.data,
                                  );
                                },
                              ),
                            )
                          : FutureBuilder<String>(
                              future: _getCustomerName(review.customerId),
                              builder: (context, nameSnapshot) {
                                return ReviewCard(
                                  review: review,
                                  customerName: nameSnapshot.data,
                                );
                              },
                            ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const Center(child: Text(StringConstant.noCommentsYet));
      },
    );
  }

  void _deleteReview(Review review, OrderViewModel orderViewModel) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(StringConstant.deleteReviewTitle),
          content: const Text(StringConstant.deleteReviewConfirmation),
          actions: [
            TextButton(
              child: const Text(StringConstant.cancel),
              onPressed: () => context.route.pop(),
            ),
            TextButton(
              child: const Text(StringConstant.delete),
              onPressed: () async {
                context.route.pop();
                try {
                  await orderViewModel.deleteReview(review.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(StringConstant.reviewDeleted),
                      backgroundColor: ColorConstant.green,
                    ),
                  );
                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('${StringConstant.errorDeletingReview}: $e'),
                      backgroundColor: ColorConstant.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Text _priceText(Product product) {
    return Text(
      '${product.price} TL',
      style: TextStyle(
        fontSize: FontSizeConstant.twentyFive.value,
        color: ColorConstant.black,
        fontWeight: FontWeightConstant.bold.value,
      ),
    );
  }

  ElevatedButton _buyButton(
      BuildContext context, Product product, OrderViewModel orderViewModel) {
    return ElevatedButton(
      onPressed: () async {
        final String userId =
            Provider.of<AuthViewModel>(context, listen: false).currentUser!.id;
        final order = CustomerOrder(
          id: '',
          customerId: userId,
          productId: product.id,
          status: StringConstant.completed,
          createdAt: DateTime.now(),
          quantity: _quantity,
          totalPrice: product.price * _quantity,
        );
        await orderViewModel.createOrder(order);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorConstant.greenAccent,
            content: Text(
              '${product.name} başarıyla satın alındı',
            ),
          ),
        );
        context.route.pop();
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size.fromWidth(context.sized.width / 4.75),
      ),
      child: Text(
        StringConstant.buy,
        style: TextStyle(fontSize: FontSizeConstant.twelve.value),
      ),
    );
  }

  Container _incrementAndDecrementButton(BuildContext context) {
    return Container(
      height: context.sized.highValue / 2,
      decoration: BoxDecoration(
        border: Border.all(color: ColorConstant.black),
        borderRadius: context.border.highBorderRadius,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _decrementQuantity,
          ),
          Text(
            '$_quantity',
            style: TextStyle(fontSize: FontSizeConstant.eightteen.value),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _incrementQuantity,
          ),
        ],
      ),
    );
  }

  AppBar _appBar(Product product, BuildContext context) {
    return AppBar(
      title: Text(product.name),
      automaticallyImplyLeading: false,
      leading: IconButton(
          onPressed: () => context.route.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded)),
    );
  }
}
