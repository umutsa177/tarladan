import 'package:flutter/material.dart';

import '../utility/constants/color_constant.dart';

class OrderListTile extends StatelessWidget {
  final String title;
  final String status;
  final String price;
  final VoidCallback? onTap;

  const OrderListTile({
    super.key,
    required this.title,
    required this.status,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
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
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildStatusChip(status),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
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
      case 'beklemede':
        chipColor = ColorConstant.coral;
        break;
      case 'tamamlandı':
        chipColor = ColorConstant.green;
        break;
      default:
        chipColor = ColorConstant.grey;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: chipColor,
    );
  }
}
