import 'package:stitch/models/constants.dart';
import 'package:stitch/models/product_color_model.dart';
import 'package:stitch/models/review_model.dart';
export 'package:stitch/models/constants.dart';

class Product{
  final String id;
  final String name;
  final int price;
  final List<String> imageUrls;
  final Set<String> categories;
  final Set<AgeGroup> ageGroups;
  final Set<Gender> genders;
  final Set<int> availableSizes;
  final Set<ProductColor> availableColors;
  final int amountLeft;
  final List<ProductReview> reviews;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrls,
    required this.categories,
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
      price: data['price'],
      imageUrls: data['imageUrls'] as List<String>,
      categories: data['categories'] as Set<String>,
      ageGroups: (data['ageGroups'] as Set<String>).map(_getAgeGroup).toSet(),
      genders: (data['genders'] as Set<String>).map(_getGender).toSet(),
      availableSizes: data['availableSizes'] as Set<int>,
      availableColors: (data['availableColors'] as Set<Map<String, dynamic>>).map(ProductColor.fromMap).toSet(),
      amountLeft: data['amountLeft'],
      reviews: (data['reviews'] as List<Map<String, dynamic>>).map(ProductReview.fromMap).toList(),
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrls': imageUrls,
      'categories': categories,
      'ageGroups': ageGroups.map((g) => g.name).toSet(),
      'genders': genders.map((g) => g.name).toSet(),
      'availableSizes': availableSizes,
      'availableColors': availableColors.map((c) => c.toMap()).toSet(),
      'amountLeft': amountLeft,
      'reviews': reviews.map((r) => r.toMap()).toList()
    };
  }
}

