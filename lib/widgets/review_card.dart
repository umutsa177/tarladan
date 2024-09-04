import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:tarladan/utility/enums/double_constant.dart';
import 'package:tarladan/utility/enums/fontsize_constant.dart';
import 'package:tarladan/utility/enums/fontweight_constant.dart';
import 'package:tarladan/utility/enums/icon_size.dart';
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
                  style: TextStyle(
                    fontWeight: FontWeightConstant.bold.value,
                    fontSize: FontSizeConstant.sixteen.value,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      List.generate(DoubleConstant.five.value.toInt(), (index) {
                    return Icon(
                      index < review.rating ? Icons.star : Icons.star_border,
                      color: ColorConstant.amber,
                      size: IconSize.smallIconSize.value,
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: context.sized.lowValue),
            Text(
              review.comment,
              style: TextStyle(fontSize: FontSizeConstant.fourteen.value),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: context.sized.lowValue / 2),
            Text(
              'Date: ${review.createdAt.toString()}',
              style: TextStyle(
                fontSize: FontSizeConstant.twelve.value,
                color: ColorConstant.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
