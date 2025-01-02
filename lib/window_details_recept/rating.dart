import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final int maxRating;
  final double currentRating;
  final Function(double) onRatingChanged;

  const StarRating({
    Key? key,
    this.maxRating = 5,
    this.currentRating = 0,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  double _currentRating = 0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.currentRating;
  }

  Widget buildStar(int index) {
    IconData icon;
    if (_currentRating >= index + 1) {
      icon = Icons.star;
    } else if (_currentRating > index && _currentRating < index + 1) {
      icon = Icons.star_half;
    } else {
      icon = Icons.star_border;
    }

    return GestureDetector(
      onTap: () {
        setState(() {

          _currentRating = index + 1.0;
        });
        widget.onRatingChanged(_currentRating);
      },
      child: Icon(
        icon,
        color: Colors.amber,
        size: 40,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.maxRating,
            (index) => buildStar(index),
      ),
    );
  }
}
