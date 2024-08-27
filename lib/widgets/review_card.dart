import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import '../model/review.dart';
import '../utility/constants/color_constant.dart';
import '../utility/constants/string_constant.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final String? customerName;

  const ReviewCard({super.key, required this.review, this.customerName});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: context.padding.verticalLow,
      child: Padding(
        padding: context.padding.normal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  customerName ??
                      '${StringConstant.customerID} ${review.customerId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < review.rating ? Icons.star : Icons.star_border,
                      color: ColorConstant.amber,
                      size: 20,
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: context.sized.lowValue),
            Text(
              review.comment,
              style: const TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: context.sized.lowValue / 2),
            Text(
              'Date: ${review.createdAt.toString()}',
              style: const TextStyle(fontSize: 12, color: ColorConstant.grey),
            ),
          ],
        ),
      ),
    );
  }
}
