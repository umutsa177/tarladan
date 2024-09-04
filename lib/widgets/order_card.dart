import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
import 'package:tarladan/utility/enums/double_constant.dart';
import 'package:tarladan/utility/enums/fontsize_constant.dart';
import 'package:tarladan/utility/enums/fontweight_constant.dart';
import '../utility/constants/color_constant.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String title;
  final String status;
  final String price;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.title,
    required this.status,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: DoubleConstant.eight.value,
          vertical: DoubleConstant.four.value),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: context.padding.normal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: FontSizeConstant.eightteen.value,
                  fontWeight: FontWeightConstant.bold.value,
                ),
              ),
              context.sized.emptySizedHeightBoxLow,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildStatusChip(status),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: FontSizeConstant.sixteen.value,
                      fontWeight: FontWeightConstant.medium.value,
                      color: ColorConstant.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case StringConstant.pending:
        chipColor = ColorConstant.coral;
        break;
      case StringConstant.completed:
        chipColor = ColorConstant.green;
        break;
      default:
        chipColor = ColorConstant.grey;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: ColorConstant.white),
      ),
      backgroundColor: chipColor,
    );
  }
}
