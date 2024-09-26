import 'package:stitch/models/constants.dart';
import 'package:stitch/models/product_color_model.dart';
import 'package:stitch/models/review_model.dart';
export 'package:stitch/models/constants.dart';

class Product{
  final String id;
  final String name;
  final String sellerId;
  final String description;
  final double price;
  final List<String> imageUrls;
  final List<String> categoryIds;
  final List<AgeGroup> ageGroups;
  final List<Gender> genders;
  final List<String> availableSizes;
  final List<ProductColor> availableColors;
  final int amountLeft;
  final List<ProductReview> reviews;

  Product({
    required this.id,
    required this.name,
    required this.sellerId,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.categoryIds,
    required this.ageGroups,
    required this.genders,
    required this.availableSizes,
    required this.availableColors,
    required this.amountLeft,
    required this.reviews,
  });

  static AgeGroup _getAgeGroup(String name){
    return switch(name.toLowerCase()){
      'toddler' => AgeGroup.toddler,
      'teen' => AgeGroup.teen,
      'youth' => AgeGroup.youth,
      'adult' => AgeGroup.adult,
      _ => AgeGroup.adult
    };
  }

  static Gender _getGender(String name){
    return switch(name.toLowerCase()){
      'female' => Gender.female,
      _ => Gender.male,
    };
  }

  static Product fromMap(Map<String, dynamic> data){
    return Product(
      id: data['id'],
      name: data['name'],
      sellerId: data['sellerId'],
      description: data['description'],
      price: data['price'],
      imageUrls: (data['imageUrls'] as List).cast<String>(),
      categoryIds: (data['categoryIds'] as List).cast<String>(),
      ageGroups: (data['ageGroups'] as List).cast<String>().map(_getAgeGroup).toList(),
      genders: (data['genders'] as List).cast<String>().map(_getGender).toList(),
      availableSizes: data['availableSizes'] as List<String>,
      availableColors: (data['availableColors'] as List<Map<String, dynamic>>).map(ProductColor.fromMap).toList(),
      amountLeft: data['amountLeft'],
      reviews: (data['reviews'] as List<Map<String, dynamic>>).map(ProductReview.fromMap).toList(),
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'sellerId': sellerId,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'categoryIds': categoryIds,
      'ageGroups': ageGroups.map((g) => g.name).toSet(),
      'genders': genders.map((g) => g.name).toSet(),
      'availableSizes': availableSizes,
      'availableColors': availableColors.map((c) => c.toMap()).toSet(),
      'amountLeft': amountLeft,
      'reviews': reviews.map((r) => r.toMap()).toList()
    };
  }
}

