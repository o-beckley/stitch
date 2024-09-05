class ProductCategory{
  final String id;
  final String name;
  final String imageUrl;

  ProductCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  static ProductCategory fromMap(Map<String, dynamic> data){
    return ProductCategory(
      id: data['id'],
      name: data['name'],
      imageUrl: data['imageUrl']
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl
    };
  }
}