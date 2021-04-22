import 'package:flutter/material.dart';
import 'package:instant_tasker/constants.dart';

class RatingBar extends StatelessWidget {
  final double rating;

  const RatingBar({Key key, this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(rating.floor(), (index) {
        return Icon(
          Icons.star,
          color: kOrangeColor,
          size: 35,
        );
      }),
    );
  }
}

class EmptyRatingBar extends StatelessWidget {
  final double rating;

  const EmptyRatingBar({Key key, this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(rating.floor(), (index) {
        return Icon(
          Icons.star_outline,
          color: kOrangeColor,
          size: 35,
        );
      }),
    );
  }
}
