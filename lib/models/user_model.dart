import 'package:stitch/models/constants.dart';
export 'package:stitch/models/constants.dart';

class StitchUser{
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final Gender gender;
  final AgeGroup ageGroup;
  final String? address;
  final List<String> favourites;
  final List<String> cart;

  StitchUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.gender,
    required this.ageGroup,
    required this.address,
    required this.favourites,
    required this.cart,
  });

  static StitchUser fromMap(Map<String, dynamic> data){
    return StitchUser(
      id: data['id'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      phoneNumber: data['phoneNumber'],
      email: data['email'],
      gender: data['gender'] == 'female' ? Gender.female : Gender.male,
      ageGroup: switch (data['ageGroup']){
        'toddler' => AgeGroup.toddler,
        'teen' => AgeGroup.teen,
        'youth' => AgeGroup.youth,
        'adult' => AgeGroup.adult,
        _ => AgeGroup.youth
      },
      address: data['address'],
      favourites: data['favourites'],
      cart: data['cart']
    );
  }

  Map <String, dynamic> toMap(){
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'gender': gender.name,
      'ageGroup': ageGroup.name,
      'address': address,
      'favourites': favourites,
      'cart': cart,
    };
  }
}