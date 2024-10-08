import 'package:stitch/models/address_model.dart';
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
  final List<Address>? addresses;
  final List<String>? favourites;
  final List<OrderItem>? cart;
  final List<String>? orderIds;

  StitchUser({
    required this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.gender,
    this.ageGroup,
    this.addresses,
    this.favourites,
    this.cart,
    this.orderIds,
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
      addresses: (data['addresses'] as List?)?.cast<Map<String, dynamic>>().map((e) => Address.fromMap(e)).toList(),
      favourites: (data['favourites'] as List?)?.cast<String>(),
      cart: (data['cart'] as List?)?.map((e) => OrderItem.fromMap(e)).toList(),
      orderIds: (data['orderIds'] as List?)?.cast<String>(),
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
      'addresses': addresses?.map((e) => e.toMap()).toList(),
      'favourites': favourites,
      'cart': cart?.map((e) => e.toMap()).toList(),
      'orderIds': orderIds,
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
    List<Address>? addresses,
    List<String>? favourites,
    List<OrderItem>? cart,
    List<String>? orderIds,
  }){
    return StitchUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      ageGroup: ageGroup ?? this.ageGroup,
      addresses: addresses ?? this.addresses,
      favourites: favourites ?? this.favourites,
      cart: cart ?? this.cart,
      orderIds: orderIds ?? this.orderIds,
    );
  }
}