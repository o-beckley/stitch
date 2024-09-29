class Address{
  final String street;
  final String city;
  final String state;
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
  });

  static Address fromMap(Map<String, dynamic> data){
    return Address(
        street: data['street'],
        city: data['city'],
        state: data['state'],
        country: data['country']
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'street': street,
      'city': city,
      'state': state,
      'country': country,
    };
  }
}