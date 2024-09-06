class ProductReview{
  final String reviewer;
  final int rating;
  final String review;
  final DateTime timeStamp;

  ProductReview({
    required this.reviewer,
    required this.rating,
    required this.review,
    required this.timeStamp,
  });

  static ProductReview fromMap(Map<String, dynamic> data){
    return ProductReview(
      reviewer: data['reviewer'],
      rating: data['rating'],
      review: data['review'],
      timeStamp: DateTime.parse(data['timeStamp'])
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'reviewer': reviewer,
      'rating': rating,
      'review': review,
      'timeStamp': timeStamp.toIso8601String()
    };
  }
}