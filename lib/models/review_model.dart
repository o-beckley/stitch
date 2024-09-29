class ProductReview{
  final String reviewerId;
  final int rating;
  final String review;
  final DateTime timeStamp;
  final List<String>? imageUrls;

  ProductReview({
    required this.reviewerId,
    required this.rating,
    required this.review,
    required this.timeStamp,
    this.imageUrls
  });

  static ProductReview fromMap(Map<String, dynamic> data){
    return ProductReview(
      reviewerId: data['reviewerId'],
      rating: data['rating'],
      review: data['review'],
      timeStamp: DateTime.parse(data['timeStamp']),
      imageUrls: data['imageUrls'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'reviewerId': reviewerId,
      'rating': rating,
      'review': review,
      'timeStamp': timeStamp.toIso8601String(),
      'imageUrls': imageUrls,
    };
  }
}