import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GymReview {
  final double rating;
  final String review;

  GymReview({required this.rating, required this.review});
}
class Review extends StatefulWidget {
  final User currentUser;

  Review({required this.currentUser});

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Rate our app',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),

          RatingBar.builder(
          initialRating: _rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 30,
          itemBuilder: (context, _) =>
              Icon(
                Icons.star,
                color: Colors.amber,
              ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        ),
        Container(
          child: Text(
            'Write review',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          height : 10.0,
        ),

        TextFormField(
          controller: _reviewController,
          decoration: InputDecoration(
            labelText: 'Review',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final review = GymReview(
              rating: _rating.toDouble(),
              review: _reviewController.text.trim(),
             // username: widget.currentUser.displayName ?? '',
            );
            _submitReview(review);
          },
          child: Text('Submit'),
        ),
      ],
    );
  }

  void _submitReview(GymReview review) async {
    if (review.rating == 0 || review.review.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide a rating and review.')),
      );
      return;
    }

    try {
      final reviewsCollection = FirebaseFirestore.instance.collection('gymReviews');

      // Retrieve the username from the user collection
      final userDoc = FirebaseFirestore.instance.collection('users').doc(
          widget.currentUser.uid);
      final userSnapshot = await userDoc.get();
      if (userSnapshot.exists) {
        final username = userSnapshot.get('username');

        // Save the review with the username in Firestore
        await reviewsCollection.add({
          'rating': review.rating,
          'review': review.review,
          'username':username,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review submitted successfully!')),
        );

        _rating = 0;
        _reviewController.clear();
      } else {
        throw ('User document does not exist');
      }
    } catch (error) {
      print('Error submitting review: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to submit the review. Please try again.')),
      );
    }
  }
}