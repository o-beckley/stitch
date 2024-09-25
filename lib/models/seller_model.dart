class StitchSeller{
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? phoneNumber;
  final String? email;
  final List<String>? products;

  StitchSeller({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.phoneNumber,
    this.email,
    this.products,
  });

  static StitchSeller fromMap(Map<String, dynamic> data){
    return StitchSeller(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        imageUrl: data['imageUrl'],
        phoneNumber: data['phoneNumber'],
        email: data['email'],
        products: data['products']
    );
  }

  Map <String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'phoneNumber': phoneNumber,
      'email': email,
      'products': products
    };
  }

  StitchSeller copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? phoneNumber,
    String? email,
    List<String>? products,
  }){
    return StitchSeller(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      products: products ?? this.products
    );
  }
}