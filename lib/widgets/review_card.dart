import 'package:flutter/material.dart';
import '../model/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(review.customerName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < review.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.comment),
          ],
        ),
      ),
    );
  }
}
