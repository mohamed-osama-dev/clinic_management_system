import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AppRatingBar extends StatelessWidget {
  const AppRatingBar({
    super.key,
    required this.initialRating,
    this.onRatingUpdate,
    this.itemSize = 20,
  });

  final double initialRating;
  final ValueChanged<double>? onRatingUpdate;
  final double itemSize;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: initialRating,
      minRating: 1,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: itemSize,
      itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: onRatingUpdate ?? (_) {},
    );
  }
}
