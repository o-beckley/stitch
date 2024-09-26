import 'package:stitch/models/order_item_model.dart';
import 'package:stitch/models/constants.dart';
export 'package:stitch/models/constants.dart';

class StitchUser{
  final String id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? email;
  final Gender? gender;
  final AgeGroup? ageGroup;
  final String? address;
  final List<String>? favourites;
  final List<OrderItem>? cart;

  StitchUser({
    required this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.gender,
    this.ageGroup,
    this.address,
    this.favourites,
    this.cart,
  });

  static AgeGroup _getAgeGroup(name){
    return switch (name){
      'toddler' => AgeGroup.toddler,
      'teen' => AgeGroup.teen,
      'youth' => AgeGroup.youth,
      'adult' => AgeGroup.adult,
      _ => AgeGroup.youth
    };
  }

  static StitchUser fromMap(Map<String, dynamic> data){
    return StitchUser(
      id: data['id'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      phoneNumber: data['phoneNumber'],
      email: data['email'],
      gender: data['gender'] == 'female' ? Gender.female : Gender.male,
      ageGroup: _getAgeGroup(data['ageGroup']),
      address: data['address'],
      favourites: (data['favourites'] as List).cast<String>(),
      cart: (data['cart'] as List?)?.map((e) => OrderItem.fromMap(e)).toList()
    );
  }

  Map <String, dynamic> toMap(){
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'gender': gender?.name,
      'ageGroup': ageGroup?.name,
      'address': address,
      'favourites': favourites,
      'cart': cart?.map((e) => e.toMap()).toList(),
    };
  }

  StitchUser copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    Gender? gender,
    AgeGroup? ageGroup,
    String? address,
    List<String>? favourites,
    List<OrderItem>? cart,
  }){
    return StitchUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      ageGroup: ageGroup ?? this.ageGroup,
      address: address ?? this.address,
      favourites: favourites ?? this.favourites,
      cart: cart ?? this.cart,
    );
  }
}