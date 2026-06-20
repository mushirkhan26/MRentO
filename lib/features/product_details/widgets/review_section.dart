import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import 'review_card.dart';
import 'rating_bar.dart';

class ReviewSection extends StatelessWidget {
  final String productId;
  const ReviewSection({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Customer reviews',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.black121212)),
        const SizedBox(height: 20),
        _buildRatingSummary(),
        const SizedBox(height: 32),
        _buildDynamicReviewsList(),
      ],
    );
  }

  Widget _buildRatingSummary() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            const Text('4.8',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black121212)),
            const SizedBox(height: 4),
            Row(
                children: List.generate(
                    5,
                    (i) => Icon(Icons.star,
                        color: i < 4
                            ? AppColors.primaryAmber
                            : AppColors.greyE5E7EB,
                        size: 14))),
            const SizedBox(height: 4),
            const Text('Real reviews',
                style: TextStyle(fontSize: 11, color: AppColors.grey707070)),
          ],
        ),
        const SizedBox(width: 35),
        const Expanded(
          child: Column(
            children: [
              RatingBar(star: 5, progress: 0.8, count: '80%'),
              RatingBar(star: 4, progress: 0.2, count: '15%'),
              RatingBar(star: 3, progress: 0.1, count: '5%'),
              RatingBar(star: 2, progress: 0.05, count: '0%'),
              RatingBar(star: 1, progress: 0.02, count: '0%'),
            ],
          ),
        ),
      ],

    );
  }

  Widget _buildDynamicReviewsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'Is equipment ka abhi koi review nahi hai.\nPehle renter bano!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.grey500),
              ),
            ),
          );
        }

        final reviews = snapshot.data!.docs;

        return Column(
          children: [
            ...reviews.take(3).map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ReviewCard(
                  name: data['userName'] ?? 'Anonymous',
                  date: 'Just now', // Ideally format timestamp
                  comment: data['comment'] ?? '',
                  initials: (data['userName'] as String? ?? 'U')[0].toUpperCase(),
                ),
              );
            }),
            if (reviews.length > 3)
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text('Sab ${reviews.length} reviews dekho',
                      style: const TextStyle(
                          color: AppColors.primaryDarkGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ),
              ),
          ],
        );
      },
    );
  }
}
