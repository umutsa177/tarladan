import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:tarladan/utility/constants/string_constant.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: context.padding.normal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              context.sized.emptySizedHeightBoxLow,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildStatusChip(status),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
