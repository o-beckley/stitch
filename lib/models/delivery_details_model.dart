import 'package:stitch/models/address_model.dart';

class DeliveryDetails{
  final Address address;
  final String phoneNumber;

  DeliveryDetails({
    required this.address,
    required this.phoneNumber,
  });

  static DeliveryDetails fromMap(Map<String, dynamic> data){
    return DeliveryDetails(
      address: Address.fromMap(data['address']),
      phoneNumber: data['phoneNumber'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'address': address.toMap(),
      'phoneNumber': phoneNumber,
    };
  }
}